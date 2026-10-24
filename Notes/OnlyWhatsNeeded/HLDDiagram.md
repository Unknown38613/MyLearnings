# HLD Diagrams + Capacity Estimation for 22 Systems

**Companion to:** `hld-components-cheatsheet.md` (that file explains *what each component is*; this one shows *how they connect* and *how big the system is*).

> **Important:** All numbers below are **illustrative assumptions for practising the method**. They are not real company data. In an interview, nobody checks your exact numbers. They check that you **state assumptions, show the math, and draw a design conclusion from it**.

---

## How each system section is organised

1. **Diagram:** simple ASCII diagram you can redraw on a whiteboard.
2. **Say it like this:** a 30-second narration of the diagram.
3. **Capacity estimation:** a table of `Assumption → Calculation → Result`, with a *why* for each assumption.
4. **What the numbers tell us:** the design decision the estimate forces (this is the part interviewers love).

---

# PART A: THE COMMON DIAGRAM (start every design here)

```
 Users
   │
   ▼
  DNS (Route 53) ─────────────► CDN (CloudFront/Akamai) ── static + media from edge
   │
   ▼
 WAF / DDoS shield
   │
   ▼
 Load Balancer (L4/L7, multi-AZ)
   │
   ▼
 API Gateway  ── auth (JWT/OAuth) • rate limit • routing • TLS
   │
   ▼
 ┌────────────────────────────────────────────────────────────┐
 │  Stateless services (Spring Boot on K8s, autoscaled)       │
 │     Service A        Service B        Service C            │
 └───┬───────────────────┬─────────────────────┬──────────────┘
     │ sync              │ sync                │ async (events)
     ▼                   ▼                     ▼
  ┌───────┐        ┌───────────┐         ┌──────────────┐
  │ Cache │        │ Primary DB│         │ Queue/Kafka  │
  │(Redis)│        │ + replicas│         └──────┬───────┘
  └───────┘        │ + shards  │                ▼
                   └───────────┘          Workers / consumers
     Blob store (S3) for files ─────────────►  │
                                               ▼
                                   Search index • Analytics • Notifications

 Cross-cutting: Logging (ELK) • Metrics (Prometheus) • Tracing (OTel/Jaeger)
                Alerts • Service discovery • Secrets (Vault) • CI/CD
```

**Say it like this:** "Traffic enters through DNS and a CDN for static content, passes WAF and a load balancer, and reaches an API gateway that handles auth and rate limiting. Behind it are stateless services that scale horizontally. State lives in a database with replicas and shards, with a cache in front for hot reads, and blob storage for large files. Anything slow or non-critical goes through a queue to workers, which also feed search, analytics, and notifications. Everything is monitored with logs, metrics, and traces."

---

# PART B: THE ESTIMATION TOOLKIT (memorise this page)

### Time conversions
| Fact | Value | Use |
|---|---|---|
| 1 day | 86,400 s ≈ **10^5 s** | `QPS ≈ requests_per_day ÷ 10^5` (rounding error is about 15%, which is fine) |
| 1 month | ≈ 2.6 × 10^6 s | monthly volume → QPS |
| 1 year | ≈ 3 × 10^7 s | |
| Shortcut | 1M requests/day ≈ **10 QPS** | |
| **Peak factor** | **2–3×** average (10× for sale/festival/top-of-hour bursts) | design for peak, not average |

### Size conversions
`1 KB = 10^3 B, 1 MB = 10^6, 1 GB = 10^9, 1 TB = 10^12, 1 PB = 10^15`
`1 Gbps = 125 MB/s`

### Typical object sizes (assumptions you can state)
| Item | Size |
|---|---|
| ID / timestamp / counter | 8 B |
| Short text record with metadata | 0.5–2 KB |
| Chat message (text + metadata) | ~200 B |
| Compressed web image | 200 KB – 2 MB |
| 1080p video bitrate | roughly 3–5 Mbps |
| Web page HTML | ~100 KB |

### Ballpark capacity of one machine (state these as assumptions)
| Component | Rough per-node capability |
|---|---|
| Stateless app server (simple API) | 1k–5k RPS |
| Redis node | ~100k ops/s, memory-bound (RAM is the limit) |
| MySQL/Postgres primary | ~5k–10k simple writes/s, ~10k+ reads/s |
| Kafka broker | ~100 MB/s sustained writes (disk and replication permitting) |
| Tuned WebSocket server | ~50k–100k concurrent connections |
| Elasticsearch data node | ~10–20k docs/s indexing |

### Latency numbers (order of magnitude)
RAM access ~100 ns • SSD random read ~100 µs • Same-datacenter round trip ~0.5 ms • HDD seek ~10 ms • Cross-continent round trip ~150 ms

### Multipliers to remember
- **Replication:** × 3 (or × 1.5 with erasure coding)
- **Headroom:** run nodes at 50–70% of capacity, so divide capacity by 0.6
- **Peak:** × 2–3
- **Little's Law:** `concurrent requests = arrival rate × latency` (used for connections, workers, in-flight calls)

### The 6-step estimation script to say out loud
1. "Let me assume **N DAU** and **X actions per user per day**." (state the assumptions)
2. `QPS = DAU × X ÷ 10^5`; "peak is about 3×."
3. `Storage/day = writes/day × size`; `× 365 × replication` for yearly.
4. `Bandwidth = QPS × payload size`.
5. `Servers = peak load ÷ per-node capacity ÷ 0.6`.
6. **"So this system is [read-heavy / write-heavy / storage-bound / memory-bound / CPU-bound], which means I'll design for ___."**

---

# PART C: THE 22 SYSTEMS

---

## 1. Distributed Cache

### Diagram
```
 App servers (smart client computes hash(key) → owning node)
        │
        ├───────────────┬────────────────┐
        ▼               ▼                ▼
   [Cache Node 1]  [Cache Node 2]   [Cache Node 3]    ◄─ hash slots / consistent-hash ring
        │ replicate       │ replicate      │ replicate
        ▼                 ▼                ▼
   [Replica 1]       [Replica 2]      [Replica 3]
        ▲
        └── gossip / Sentinel: failure detection + automatic failover

 Cache-aside:  GET key ─► hit → return
                         miss → read Primary DB → SET key with TTL → return
```

**Say it like this:** "The client library hashes the key to find the owning node using consistent hashing or hash slots, so adding a node moves only a small share of keys. Each node has a replica for failover. On a miss, the app reads the database and populates the cache with a TTL. Eviction is LRU/LFU when memory is full."

### Capacity estimation
| Step | Calculation | Result | Why this assumption |
|---|---|---|---|
| Requests/day | 100M DAU × 100 cache ops | 10B/day | Cache sits in front of many calls per user session |
| Avg QPS | 10B ÷ 10^5 | **100k/s** | |
| Peak QPS | 100k × 3 | **300k/s** | Standard peak factor |
| Read:write | assume 10:1 | ~90k reads, ~10k writes/s | Caches are read-dominated |
| Backing data | assume 2.5 TB in DB | | |
| Working set | 20% of 2.5 TB (80/20 rule) | **500 GB** | Typically 20% of data serves 80% of traffic |
| Keys | 500 GB ÷ 1 KB per entry | 500M keys | Avg value + key + overhead ≈ 1 KB |
| Nodes (memory) | 500 GB ÷ 50 GB usable per 64 GB node | **10 nodes** | Leave about 20% RAM for fragmentation and overhead |
| With 1 replica each | 10 × 2 | **20 nodes** | HA |
| Nodes (CPU) | 300k ÷ 100k per node | 3 nodes | |
| Bandwidth | 300k × 1 KB | **300 MB/s ≈ 2.4 Gbps** | |

**What the numbers tell us:** Memory needs 10 nodes while throughput needs only 3, so it is **memory-bound**. Size the cluster by RAM, tune eviction and TTLs carefully, and watch for hot keys.

---

## 2. Distributed Messaging Queue (Kafka-style)

### Diagram
```
 Producers ─► [Partitioner: hash(key) % N] ─► Broker cluster
                                              ┌──────────────────────────────────────┐
                                              │ Topic "orders"                       │
                                              │  P0: leader B1  followers B2,B3      │
                                              │  P1: leader B2  followers B3,B1      │
                                              │  P2: leader B3  followers B1,B2      │
                                              └───────────────┬──────────────────────┘
   Controller (KRaft/ZooKeeper): metadata, leader election    │
                                                              ▼
                       Consumer Group A:  C1 ◄─P0   C2 ◄─P1   C3 ◄─P2   (offsets committed)
                                                              │ on repeated failure
                                                              ▼
                                                  [Retry topic] ─► [DLQ]
```

**Say it like this:** "Producers pick a partition by key so per-key ordering is preserved. Each partition is an append-only log with a leader and replicas for durability. Consumers in a group split the partitions and commit offsets, so a crashed consumer's partitions are reassigned. Failed messages go to a retry topic and then a DLQ."

### Capacity estimation
| Step | Calculation | Result | Why this assumption |
|---|---|---|---|
| Messages/day | assume 10B | | Large internal event bus |
| Avg rate | 10B ÷ 10^5 | **100k msg/s** | |
| Peak rate | × 3 | **300k msg/s** | |
| Message size | 1 KB | | Typical JSON/Avro event |
| Ingress | 100k × 1 KB / 300k × 1 KB | **100 MB/s avg, 300 MB/s peak** | |
| Storage/day | 100 MB/s × 10^5 s | **10 TB/day** | |
| Retention 7 days | 10 TB × 7 | 70 TB | Typical default is 7 days to allow replay |
| Replication ×3 | 70 × 3 | **210 TB** | Durability |
| Brokers by storage | 210 TB ÷ (10 TB disk × 70% usable) | **~30 brokers** | Don't fill disks past 70% |
| Brokers by throughput | 300 MB/s × 3 replicas = 900 MB/s ÷ 100 MB/s | ~9 brokers | |
| Partitions | 300 MB/s ÷ 10 MB/s per partition = 30 minimum; choose **100–200** | | Extra partitions give consumer parallelism |

**What the numbers tell us:** Storage needs about 30 brokers and throughput needs about 9, so it is **storage-bound**. Retention length is the main cost lever. Partition count is hard to change later, so over-provision it modestly.

---

## 3. Distributed Pub-Sub

### Diagram
```
 Publisher ─► [Topic] ─► Fan-out service
                │             │
                │             ├─► [Subscription A: cursor/queue] ─► Subscriber A (pull)
                │             ├─► [Subscription B: cursor/queue] ─► Push worker ─► HTTPS endpoint B
                │             │                                       (retry w/ backoff ─► DLQ)
                │             └─► [Subscription C: cursor/queue] ─► Subscriber C (filter: type=payment)
                ▼
        [Message store: retained N days, replay via seek]
```

**Say it like this:** "A publisher writes once to a topic. Each subscription has its own cursor, so a slow subscriber never blocks a fast one. Delivery is pull or push with retry and a DLQ. Messages are retained for some days so a subscriber can replay by seeking its cursor. The difference from a queue is that every subscription receives every message."

### Capacity estimation
| Step | Calculation | Result | Why this assumption |
|---|---|---|---|
| Publishes/day | assume 500M | | |
| Publish rate | 500M ÷ 10^5 | 5k/s avg, **15k/s peak** | |
| Avg subscriptions per topic | 5 | | Typical fan-out for internal events |
| Deliveries | 5k × 5 | 25k/s avg, **75k/s peak** | Fan-out multiplies the delivery load |
| Message size | 2 KB | | |
| Ingress | 5k × 2 KB | 10 MB/s | |
| Egress | 25k × 2 KB | 50 MB/s avg, 150 MB/s peak | |
| Storage | 500M × 2 KB = 1 TB/day × 3 days × 3 replicas | **9 TB** | Short retention is enough for replay |
| Nodes | peak egress 150 MB/s → 3 by bandwidth; use **6** | | 2 per AZ across 3 AZs for HA |

**What the numbers tell us:** Egress is 5× ingress because of fan-out, so scale delivery workers separately from ingestion. Storage is small, so the work is in delivery tracking and retries.

---

## 4. Distributed Rate Limiter

### Diagram
```
 Client ─► LB ─► API Gateway
                    │ 1. identify caller (API key / user id / IP)
                    │ 2. load rule  ◄── [Rules store: etcd/DB + local cache]
                    │ 3. atomic check (Lua script)
                    ▼
            [Redis Cluster: sharded by client key]
              token bucket per key: {tokens, last_refill_ts}
                    │
            allowed ◄──┴──► rejected ─► HTTP 429 + Retry-After + X-RateLimit-* headers
               │
               ▼
        Backend services
```

**Say it like this:** "The gateway identifies the caller, loads that caller's rule, and runs one atomic Lua script in Redis that refills and consumes a token bucket. Because it's atomic there are no race conditions across gateway nodes. If rejected, we return 429 with Retry-After. Redis is sharded by client key, and we decide fail-open or fail-closed if Redis is down."

### Capacity estimation
| Step | Calculation | Result | Why this assumption |
|---|---|---|---|
| Protected API peak | assume 500k RPS | | Large public API |
| Redis ops | 1 atomic op per request | **500k ops/s** | |
| Shards | 500k ÷ (100k × 0.6 utilisation) | **~9–10 shards** | Redis does ~100k ops/s per node; keep headroom |
| Active clients | assume 10M in the window | | |
| Memory (token bucket) | 10M × ~200 B (key + 2 fields + overhead) | **~2 GB** | |
| Memory (sliding window log) | 10M × ~1 KB (100 timestamps × 8 B + overhead) | **~10 GB** | |
| Latency budget | < 2 ms added per request | | Limiter must not hurt the API's latency |

**What the numbers tell us:** Token bucket uses about 5× less memory than a sliding-window log, so choose it unless exact windows are required. Throughput, not memory, drives the shard count here, so keep a local fast-path for obvious allows if latency matters.

---

## 5. Distributed Blob Store (S3-like)

### Diagram
```
 Client ─► Front-end API ─► Auth (IAM / bucket policy)
              │ (1) PUT intent
              ▼
       [Metadata Service] ◄──► [Metadata DB (sharded): key → chunk ids + locations + checksum]
              │ (2) pick placement (rack / AZ aware)
              ▼
  Client streams chunks (multipart, presigned URL)
              ▼
   [Data Node 1] ──► [Data Node 2] ──► [Data Node 3]    replicate ×3  or  erasure-code (6+3)
        ▲  heartbeats • checksums • scrubber • re-replication on node loss
              │ (3) commit chunk list
              ▼
       [Metadata Service]
 GET: metadata lookup ─► read chunks (parallel) ─► (CDN in front for hot objects)
 Background: lifecycle (hot→cold), garbage collection of deleted chunks
```

**Say it like this:** "Metadata and data are separated. The metadata service maps a key to chunk locations, and data nodes store chunks, replicated three times or erasure-coded to save space. Clients upload multipart directly to data nodes through presigned URLs, so API servers never carry the bytes. Heartbeats detect failed nodes and trigger re-replication, and a scrubber verifies checksums."

### Capacity estimation
| Step | Calculation | Result | Why this assumption |
|---|---|---|---|
| Uploads/day | assume 10M | 100 PUT/s avg, **300/s peak** | |
| Reads | 10:1 | 1k GET/s avg, **3k/s peak** | Storage is read-heavy |
| Avg object size | 2 MB | | Mix of small files and larger media |
| Data/day | 10M × 2 MB | **20 TB/day** | |
| Per year | 20 TB × 365 | **7.3 PB** | |
| With 3× replication | 7.3 × 3 | **22 PB** | |
| With erasure coding 6+3 (1.5×) | 7.3 × 1.5 | **11 PB** | Cuts cost in half |
| Ingress bandwidth | 20 TB ÷ 10^5 s | 200 MB/s | |
| Egress bandwidth | 10 × ingress | **2 GB/s ≈ 16 Gbps** | |
| Metadata | 3.65B objects/yr × 200 B | **730 GB/yr** | Key + size + checksum + chunk pointers |
| Storage servers (EC) | 11 PB ÷ 100 TB raw per server | **~110 servers** | vs about 220 with 3× replication |

**What the numbers tell us:** It is **storage-cost-bound**. Erasure coding halves the hardware bill, at the price of costlier repairs. Metadata is tiny (730 GB), so a sharded KV store handles it, but it sits on the critical path of every operation, so cache it and keep it highly available.

---

## 6. Distributed Search

### Diagram
```
 Source DB ──CDC (Debezium)──► Kafka ──► Indexer (analyze: tokenize, stem, stop-words)
                                              │
                                              ▼
                            ┌───────────────────────────────────┐
 User ─► LB ─► Search API ─►│ Coordinator node                  │
       (cache, suggest)     │   scatter ──► Shard 1 (+replica)  │
                            │   scatter ──► Shard 2 (+replica)  │
                            │   scatter ──► Shard N (+replica)  │
                            │   gather top-K ◄── each shard     │
                            └───────────────┬───────────────────┘
                                            ▼ merge + rank (BM25, optional ML re-ranker)
                                         results
 Master nodes: cluster state, shard allocation
```

**Say it like this:** "The database is the source of truth. Changes flow through CDC and Kafka to an indexer that builds an inverted index split into shards, each with a replica. A query hits a coordinator that scatters it to every shard, takes each shard's top-K, merges and ranks them, and returns the result."

### Capacity estimation
| Step | Calculation | Result | Why this assumption |
|---|---|---|---|
| Documents | assume 100M | | |
| Avg doc size | 10 KB | | Mid-size text records |
| Raw data | 100M × 10 KB | **1 TB** | |
| Index size | ≈ 1× raw | ~1 TB | Depends on analyzers and fields, typically 0.5–1.5× |
| Shard size | target 40 GB | 1 TB ÷ 40 GB = **25 primary shards** | Common guidance is 10–50 GB per shard |
| With 1 replica | 25 × 2 | **50 shards, 2 TB** | |
| Search volume | assume 50M searches/day | 500/s avg, **1.5k/s peak** | |
| Shard-queries | 1.5k × 25 shards | **37.5k shard-queries/s** | Every query touches every shard |
| CPU | 37.5k × ~5 ms | **~190 cores** | Assume about 5 ms CPU per shard-query |
| Data nodes | 190 ÷ 16 cores | **~12 nodes** | |
| Indexing | 1M new docs/day | ~10 docs/s | Trivial |

**What the numbers tell us:** Storage needs only about 10 nodes of 200 GB each, but CPU needs about 12 nodes, so it is **CPU/query-bound, not storage-bound**. Scatter-gather means more shards raise per-query cost, which is why shard count is a deliberate trade-off.

---

## 7. Distributed Logging System

### Diagram
```
 App / container ─► Agent (Fluent Bit / Filebeat) ─► Kafka (buffer, absorbs spikes)
                                                          │
                                                          ▼
                                              Processor (parse, enrich, mask PII)
                                          ┌───────────────┴────────────────┐
                                          ▼                                ▼
                         HOT store: Elasticsearch/Loki (7 days)   COLD store: S3 (90+ days, compressed)
                                          │
                                          ▼
                              Kibana / Grafana ──► Alerts (error-rate rules)
```

**Say it like this:** "A lightweight agent on every host ships structured logs to Kafka, which decouples producers from storage and absorbs spikes. A processor parses and masks PII, then writes to a hot searchable store for recent logs and to cheap compressed object storage for older ones. Kibana or Grafana query the hot store, and alert rules run on top."

### Capacity estimation
| Step | Calculation | Result | Why this assumption |
|---|---|---|---|
| Sources | 2,000 service instances × 50 lines/s | **100k lines/s avg** | Typical busy service logs tens of lines per second |
| Peak | × 3 | **300k lines/s** | Incidents produce log storms |
| Line size | 300 B | | Structured JSON log line |
| Throughput | 100k × 300 B | **30 MB/s avg, 90 MB/s peak** | |
| Per day | 30 MB/s × 10^5 | **3 TB/day** | |
| Hot, 7 days | 3 × 7 | 21 TB × 2 (1 replica) = **42 TB** | Recent logs are queried the most |
| Elasticsearch nodes by ingest | 300k ÷ 15k docs/s per node | **~20 nodes** | |
| Elasticsearch nodes by storage | 42 TB ÷ 4 TB per node | ~11 nodes | |
| Cold, 90 days | 3 TB ÷ 8 (compression) × 90 | **~34 TB** on S3 | Compressed text shrinks about 5–10× |
| Kafka buffer | 3 TB (24 h) × 3 replicas | **9 TB**, 3–6 brokers | A day of buffer survives downstream outages |

**What the numbers tell us:** It is **ingest-bound** (20 nodes for ingest vs 11 for storage), and most cost sits in the hot index. Tier aggressively, sample debug logs, and index only what you search (Loki indexes labels only).

---

## 8. Distributed Task Scheduler

### Diagram
```
 Client/API ─► [Job Service] ─► [Jobs DB: id, cron, next_run, payload, status, owner]
                                      ▲
                                      │ scan: next_run ≤ now (per partition, indexed)
                         [Scheduler nodes: each owns partitions via ZooKeeper/etcd lease]
                                      │ enqueue due jobs
                                      ▼
                                [Queue: Kafka/SQS]
                                      ▼
                         [Worker pool] ── heartbeat/lease ──► [Status & history store]
                                      │
                       failure ─► retry w/ backoff ─► DLQ
                       success ─► compute next_run ─► update Jobs DB
```

**Say it like this:** "Jobs live in a DB with an indexed next_run. Scheduler nodes each own a partition of jobs through a lease in ZooKeeper or etcd, so two nodes never fire the same job. Due jobs are pushed to a queue, workers execute them under a lease with heartbeats, and a crashed worker's job is reassigned. Delivery is at-least-once, so jobs must be idempotent."

### Capacity estimation
| Step | Calculation | Result | Why this assumption |
|---|---|---|---|
| Executions/day | assume 50M | **500/s avg** | |
| Peak | 10× (top of minute/hour) | **5k/s** | Cron jobs cluster at round times |
| Jobs defined | 10M × 1 KB | **10 GB** | Fits in one DB, so shard later for growth |
| Execution history | 50M × 200 B | 10 GB/day; 30 days = **300 GB** | |
| Job duration | avg 10 s | | Assumption |
| Concurrent jobs (Little's Law) | 500 × 10 s | **5k avg**, 5k × 10 = **50k peak** | `concurrency = rate × duration` |
| Workers | 50k ÷ 50 concurrent per worker | **~1,000 at peak** (autoscaled; ~100 avg) | I/O-bound jobs run many per worker |
| Scheduler partitions | 5k/s ÷ 16 partitions | ~300 jobs/s each | One scan query per partition per second |

**What the numbers tell us:** Metadata is small and queue throughput is trivial, so the **difficulty is burstiness and reliability**, not size. Spread job times with jitter, autoscale workers, and use leases plus idempotency for correctness.

---

## 9. Video Streaming Platform (YouTube / Netflix)

### Diagram
```
 UPLOAD PATH
 Creator ─► Upload svc (resumable, chunked) ─► [Raw store: S3] ─► [Queue] ─► Orchestrator (DAG)
                                                                      ┌───────────┴──────────────┐
                                                                      ▼                          ▼
                                                  Splitter ─► Parallel Encoders          Thumbnails • Moderation • DRM
                                                  (240p…4K; H.264 / VP9 / AV1)
                                                                      ▼
                                                      Packager (HLS/DASH + manifest)
                                                                      ▼
                                              [Origin store: S3] ─► CDN        Metadata DB (status=READY) ─► Search index

 PLAYBACK PATH
 Viewer ─► API (metadata + manifest URL) ─► CDN edge ──miss──► Origin store
 Player (ABR) picks each chunk's quality based on measured bandwidth
 Side channel: view events ─► Kafka ─► Flink ─► view counts, recommendations
```

**Say it like this:** "Uploads go straight to object storage. A workflow splits the video, encodes it in parallel into a bitrate ladder across codecs, packages it into HLS/DASH chunks with a manifest, and publishes it to an origin behind a CDN. Playback fetches the manifest and the player adaptively picks chunk quality by bandwidth. Almost all bytes come from CDN edges, never from my servers."

### Capacity estimation
| Step | Calculation | Result | Why this assumption |
|---|---|---|---|
| DAU | 100M | | Large platform (illustrative) |
| Watching | 5 videos × 5 min per user | **2.5B minutes/day** | |
| Avg bitrate | 2.5 Mbps = 0.31 MB/s ≈ 19 MB/min | | Blend of 480p–1080p |
| Egress/day | 2.5B × 19 MB | **~47 PB/day** | |
| Avg bandwidth | 47 PB ÷ 10^5 s | **~3.8 Tbps** | |
| Peak | × 2.5 | **~10 Tbps** | |
| CDN hit ratio 95% | origin = 5% × 10 Tbps | **~0.5 Tbps at origin** | Popular content dominates |
| Play starts | 100M × 5 = 500M/day | 5k/s avg, **15k/s peak** | Each start requests metadata + manifest |
| Uploads | assume 1M/day | ~10/s | ~1 upload per 100 DAU |
| Raw size | 200 MB avg | **200 TB/day** | |
| Renditions | assume total ≈ 1× raw | +200 TB/day | Ladder of several resolutions |
| Total storage | 400 TB/day × 365 | **~146 PB/year** | |
| Transcode compute | assume ~1 CPU-hour per video | 1M CPU-hours/day ÷ 24 = **~42k vCPUs** → ÷ 16 = **~2.6k machines** | Rough assumption; use autoscaled spot capacity |
| Metadata | 365M videos/yr × 2 KB | **~730 GB/yr** | Small, so sharded SQL works |

**What the numbers tell us:** Egress is about 47 PB/day, so **the CDN is the whole delivery strategy** (this is why Netflix places appliances inside ISPs). Storage is a hundred-plus PB/year, so encode popular videos fully and long-tail ones lazily. Metadata is tiny. The only really heavy compute is transcoding, which is parallelisable and queue-driven.

---

## 10. Video + Image Intensive Platforms (Instagram / TikTok)

### Diagram
```
 POST PATH
 Client ─► Upload svc ─► Blob store ─► Media pipeline (resize/transcode/moderate) ─► CDN
 Client ─► Post svc ─► [Post DB]  ─► Kafka ─► Fan-out workers
                                                  │ followers list from [Social Graph store]
                                   ┌──────────────┴─────────────────┐
                                   ▼ normal accounts: push post_id  ▼ celebrity accounts: skip (pull at read)
                          [Feed cache: Redis ZSET per user, ~500 post_ids]

 READ PATH
 Client ─► Feed svc ─► Feed cache (ids) ⊕ celebrity posts (pull) ─► Ranker (ML) ─► hydrate from Post cache/DB
        ─► response has post metadata + media URLs ─► media fetched from CDN
 Counters: likes/comments ─► Redis ─► Kafka ─► DB (async)
```

**Say it like this:** "Media goes straight to blob storage and a pipeline produces resized images or short-video renditions behind a CDN. Metadata goes to a post DB, and a fan-out worker pushes the post ID into followers' feed caches. For celebrities with millions of followers we skip the push and merge their posts at read time (hybrid fan-out). A feed read is just IDs from Redis, ranked and hydrated, with media served from the CDN."

### Capacity estimation
| Step | Calculation | Result | Why this assumption |
|---|---|---|---|
| DAU | 200M | | |
| New posts | 5% post daily = **10M/day** | 100/s avg, 300/s peak | Most users consume, few create |
| Avg media per post | 80% images × 2.5 MB + 20% short videos × 40 MB = 2 + 8 | **10 MB** | Video dominates storage |
| Storage | 10M × 10 MB | **100 TB/day → 36.5 PB/yr** | Before replication |
| Feed requests | 200M × 10 per day | **20k/s avg, 60k/s peak** | 10 refresh/scroll calls × 10 posts ≈ 100 posts viewed |
| Avg followers | 200 | | |
| Fan-out writes | 10M posts × 200 | 2B/day = **20k/s avg, 60k/s peak** | Celebrities excluded |
| Feed cache | 500 ids × 8 B = 4 KB/user × 200M | **800 GB** | |
| With 1 replica | × 2 | 1.6 TB ÷ 50 GB/node = **~32 Redis nodes** | |
| Media egress | 100 posts × 300 KB = 30 MB/user/day × 200M | **6 PB/day ≈ 0.5 Tbps avg, ~1.2 Tbps peak** | 300 KB blends images with video thumbnails/previews |

**What the numbers tell us:** Feed reads (60k/s) dwarf posts (300/s), so **pre-compute feeds at write time** (fan-out on write). Fan-out multiplies writes 200×, so celebrities must be handled differently. Media bandwidth is far beyond origin capacity, so **CDN again**.

---

## 11. Text-Heavy Platforms (Twitter / Reddit)

### Diagram
```
 WRITE:
 Client ─► Tweet svc ─► ID generator (Snowflake) ─► [Tweet DB, sharded]
                              │
                              ├─► Kafka ─► Fan-out ─► [Timeline cache: Redis list per user]   (uses [Social Graph])
                              ├─► Kafka ─► Indexer ─► [Search: Lucene/ES]
                              └─► Kafka ─► Flink ─► [Trending: windowed top-K / Count-Min Sketch]

 READ:
 Client ─► Timeline svc ─► Redis (tweet ids) ⊕ celebrity tweets ─► hydrate (tweet cache/DB) ─► response

 REDDIT ADDITIONS:
 Vote svc ─► Redis counters ─► periodic "hot" rank job ─► ranked listing cache
 Comments ─► tree store (materialized path / adjacency list), paginate deep threads
```

**Say it like this:** "Posts get a time-sortable Snowflake ID and are stored in a sharded DB. An async fan-out pushes the ID into followers' timeline lists in Redis, except for celebrities whose tweets are merged at read time. Separate consumers feed the search index and a streaming job that computes trending topics. Reading a timeline is a Redis lookup plus hydration."

### Capacity estimation
| Step | Calculation | Result | Why this assumption |
|---|---|---|---|
| DAU | 200M | | |
| Tweets/day | 0.5 per DAU = **100M** | **1k/s avg, 3k/s peak** | Most users read more than they write |
| Timeline reads | 200M × 10 refreshes | **20k/s avg, 60k/s peak** | **20:1 read:write** |
| Tweet record | ~1 KB (280 chars + ids, counts, timestamps) | 100M × 1 KB = **100 GB/day = 36.5 TB/yr** | Text is small |
| Media | 20% of tweets × 500 KB | 20M × 0.5 MB = **10 TB/day = 3.65 PB/yr** | Media dwarfs text |
| Timeline cache | 800 ids × 8 B = 6.4 KB × 200M | **1.28 TB; × 2 = 2.6 TB → ~52 Redis nodes** | |
| Fan-out writes | 100M × 200 avg followers | 20B/day = **200k/s avg, 600k/s peak** | |
| Fan-out capacity | 600k ÷ 100k ops/s per node | 6 nodes' worth | Covered by the 52 nodes needed for memory |

**What the numbers tell us:** Text is only 36 TB/year, so **the DB is not the challenge**. The challenge is the **200k-600k/s fan-out write rate** and **timeline memory**. That's why the hybrid push/pull model exists. Media (PBs) goes to blob + CDN.

---

## 12. Google Maps

### Diagram
```
 MAP VIEW
 Client ─► CDN (tiles /z/x/y) ──miss──► Tile svc ─► [Tile store: S3/blob]
                                              ▲ built offline: Map data pipeline (OSM, satellite, ML) ─► tile renderer

 ROUTING
 Client ─► Gateway ─► Geocoder ─► Routing svc (Contraction Hierarchies / A*, partitioned road graph)
                                      │  ◄─ live speeds per road segment [Traffic store: Redis]
                                      ▼
                                  ETA svc (ML on live + historical traffic) ─► route + ETA

 LIVE TRAFFIC PIPELINE
 GPS probes ─► Kafka ─► Map-matching (snap to road) ─► Flink (aggregate speed per segment) ─► Traffic store

 PLACES / SEARCH
 Places search ─► Elasticsearch + geo index (S2 / Geohash / Quadtree)
```

**Say it like this:** "The map is pre-rendered into tiles by zoom level and served from a CDN, so panning is just cache hits. Routing runs on a partitioned road graph with precomputed shortcuts, using live speed per road segment. Those speeds come from a streaming pipeline that snaps anonymous GPS pings to roads and aggregates them. An ETA model combines live and historical traffic."

### Capacity estimation
| Step | Calculation | Result | Why this assumption |
|---|---|---|---|
| Users | 100M DAU × 10 map views | | |
| Tiles/view | ~20 | 100M × 10 × 20 = **20B tiles/day = 200k/s avg, 600k/s peak** | A screen needs about 15 tiles plus a prefetch margin |
| Tile size | 20 KB (vector tile) | **egress 400 TB/day = 4 GB/s ≈ 32 Gbps avg** | |
| CDN hit 95% | origin = 5% × 200k | **~10k tile/s at origin** | Popular areas dominate |
| Tiles in world | Σ 4^z for z ≤ 17 ≈ 4^17 × 4/3 ≈ **23B** | | Each zoom level has 4× the tiles |
| Non-empty share | assume 20% (oceans/empty are skipped) | 4.6B × 20 KB ≈ **~90 TB** | Deeper zooms are rendered on demand |
| Navigation | assume 20M sessions/day × 30 min | concurrent = 20M × 30 ÷ 1,440 ≈ **417k avg, ~2M peak** | Rush hour is about 5× average |
| GPS pings | 1 per 5 s per navigating user | 417k ÷ 5 = **83k/s avg, ~400k/s peak** | |
| Ping size | 100 B | ~8 MB/s avg | |
| Route requests | 20M sessions × 3 (initial + reroutes) | 60M/day = 600/s avg, **~1.8k/s peak** | |
| Routing CPU | 1.8k × ~50 ms | **~90 cores → ~200 with headroom** | CH queries are fast; assumption |
| Road graph | assume ~1B edges × 50 B = **~50 GB**; with shortcuts ×3 ≈ **~150 GB** | | Order of magnitude; keep in RAM across a few big-memory nodes |

**What the numbers tell us:** The system has two different shapes. **Tiles are an egress/CDN problem** and are static and cacheable. **Routing is a compute and memory problem** (graph in RAM, precomputed shortcuts). **Traffic is a streaming ingest problem** (hundreds of thousands of pings/s).

---

## 13. Payment Systems (Razorpay / Stripe)

### Diagram
```
 Merchant ─► API Gateway (auth, HMAC, Idempotency-Key) ─► Payment svc (state machine) ─► [Payments DB: ACID]
                                                              │
                                                  risk check ─► Fraud engine (rules + ML)
                                                              ▼
                                           Orchestrator / Router ─► PSP / Bank / UPI / Card network
                                                              │  ◄── async callback  or  status polling
                                                              ▼
                                       Ledger svc (double-entry) ── same DB transaction ── Outbox table
                                                              ▼
                                  Kafka ─► Webhook svc ─► Merchant (signed, retry w/ backoff)
                                       ├─► Settlement & Payout svc
                                       └─► Reconciliation (nightly batch vs bank files)

 Card data lives only in an isolated Vault (tokenization + HSM) to keep PCI-DSS scope small.
```

**Say it like this:** "Every request carries an idempotency key, so retries never double-charge. A payment is a state machine in an ACID database. We route it to a bank or PSP, and because that call can time out we never assume failure, we query status. The ledger entry and an outbox event are written in the same transaction, which drives webhooks, settlement, and nightly reconciliation. Raw card data never leaves an isolated vault."

### Capacity estimation
| Step | Calculation | Result | Why this assumption |
|---|---|---|---|
| Transactions/day | assume 10M | **100 TPS avg** | |
| Peak | 10× (festival / flash sale) | **~1,000 TPS** | Payments spike hard on sale days |
| Data per txn | payment record ~2 KB + ~4 ledger entries × 200 B ≈ **3 KB** | 10M × 3 KB = **30 GB/day ≈ 11 TB/yr** | |
| With events/audit | ≈ × 2 | **~22 TB/yr** | Immutable audit trail |
| DB writes | ~5 per txn × 1k TPS | **~5k writes/s peak** | A strong primary can handle this, so shard by `merchant_id` for growth |
| Webhooks | 3 events per txn × 10M | 30M/day = **300/s avg, ~3k/s peak** | created, authorized/captured, settled |
| Idempotency store | 10M × 100 B | ~1 GB/day; keep 24–48 h = **1–2 GB** | Fits in Redis or the DB |
| In-flight calls | 1k TPS × ~3 s bank latency | **~3k concurrent** | Little's Law |

**What the numbers tell us:** Volume is modest (about 1k TPS, 22 TB/yr). **Payments are a correctness problem, not a scale problem.** Spend design effort on idempotency, state machines, ledger integrity, reconciliation, and tolerating slow banks (async plus timeouts), not on sharding tricks.

---

## 14. Ride-Sharing App (Uber / Ola)

### Diagram
```
 Driver app ──GPS every 4 s──► Location gateway ─► Kafka ─► Location svc ─► [Live geo index: Redis GEO / in-memory H3 grid]
                                                                │ (latest position only)
                                                                └─► breadcrumb store (in-trip only) ─► S3 / Cassandra

 Rider app ─► Trip svc ─► [Trip DB: state machine]
                  │ request ride
                  ▼
              Dispatch/Matching ─► query nearby drivers (H3 cells) ─► rank by ETA ◄─ Routing/ETA svc
                  │ offer to best driver (timeout ─► next driver)
                  ▼
              Push to both apps (WebSocket / FCM / APNs) ─► live tracking
 Trip end ─► Fare calc ─► Payment svc ─► Notification svc
 Surge: supply/demand per H3 cell (Flink) ─► Pricing svc
```

**Say it like this:** "Drivers stream their location every few seconds into a geospatial index kept in memory, only the latest position. When a rider requests a ride, dispatch queries nearby cells, ranks candidates by ETA, and offers to the best driver with a timeout. The trip is a state machine in a DB, and both apps get real-time updates over persistent connections. Pricing reads a streaming supply/demand count per cell."

### Capacity estimation
| Step | Calculation | Result | Why this assumption |
|---|---|---|---|
| Rides/day | assume 10M | **100/s avg, 300/s peak** | |
| Concurrent rides | 10M × 20 min ÷ 1,440 min = **~139k avg**; × 2.5 peak = **~350k** | | Ride duration 20 min |
| Drivers online (peak) | assume ~3× in-trip drivers | **~1M** | Includes idle drivers waiting for requests |
| Location updates | 1M ÷ 4 s | **250k/s peak** | |
| Update size | 100 B (id, lat/long, timestamp, heading, status) | **~25 MB/s** | |
| Live state in memory | 1M × 100 B | **~100 MB** | Only the *latest* position per driver, so tiny |
| Breadcrumbs persisted | in-trip only: 350k ÷ 4 s = 87k/s × 100 B ≈ 8.7 MB/s | **≤ ~0.9 TB/day** (upper bound: peak rate all day) | Needed for trip receipts and disputes |
| Connections | 350k riders + 1M drivers | **~1.35M** | |
| Gateway nodes | 1.35M ÷ 50k per node | **~27, so about 30** | |

**What the numbers tell us:** Writes are huge (250k/s) but **the live state is only 100 MB**, so keep it in memory and never write every ping to a SQL DB. The matching problem is about **low latency and correctness (a driver must not be double-assigned)**, not storage. Shard by geography (city/H3 region).

---

## 15. Notification System

### Diagram
```
 Producer services ─► Notification API ─► validate • dedupe (Redis) • rate-limit
                                                │
                                                ▼
                                     Preference svc (opt-out, quiet hours, channel choice)
                                                │
                                                ▼
                                     Template svc (render, i18n)
                                                │
                                                ▼
                                   Priority router (OTP = high, marketing = low)
                       ┌──────────────┬───────────────┬──────────────┬────────────────┐
                       ▼              ▼               ▼              ▼                ▼
                  [Push queue]   [SMS queue]     [Email queue]  [In-app queue]   [WhatsApp queue]
                       │ FCM/APNs      │ SMS vendor     │ SES/SendGrid   │ WebSocket
                       ▼               ▼                ▼                ▼
                    Workers ─► providers ─► delivery callbacks (delivered/bounced/opened) ─► Tracking DB + analytics
                    failure ─► retry w/ backoff ─► DLQ ;  vendor failover for SMS/email
```

**Say it like this:** "Services call one notification API. It dedupes and rate-limits, checks the user's preferences, renders a template, and routes to a per-channel, per-priority queue so an OTP is never stuck behind a marketing blast. Channel workers call the providers (FCM/APNs, SMS and email vendors), retry with backoff, and fall back to a DLQ or a backup vendor. Provider callbacks update delivery status."

### Capacity estimation
| Step | Calculation | Result | Why this assumption |
|---|---|---|---|
| Users | 100M × 10 notifications/day | **1B/day = 10k/s avg** | Includes transactional + engagement |
| Peak | 10× (campaign / sale launch) | **100k/s** | Marketing blasts cause bursts |
| Channel mix | 70% push, 15% email, 10% in-app, 5% SMS | Push 700M/day; **SMS 50M/day = 500/s avg, ~5k/s peak** | SMS is costly and limited, so use it sparingly |
| Payload | 1 KB | **1 TB/day through queues** | |
| Queue storage | 1 TB × 3 days × 3 replicas | **9 TB** | |
| Delivery log | 200 B × 1B | **200 GB/day; 30 days = 6 TB** | Needed for tracking and support |
| Provider call latency | ~200 ms | In-flight = 100k × 0.2 = **20k concurrent calls** | Little's Law |
| Workers | 20k ÷ 200 connections per worker | **~100 workers (autoscaled)** | |

**What the numbers tell us:** Volume is moderate. **The constraints are external:** provider rate limits (especially SMS), burst absorption, and priority isolation. Design for **per-channel queues, backpressure, vendor failover, and dedupe**, not heavy storage.

---

## 16. Distributed URL Shortener

### Diagram
```
 CREATE:
 Client ─► LB ─► Shorten svc ─► Key generation (KGS pool / counter ranges / Snowflake → Base62)
                      │
                      ▼
               [URL DB: key → long_url, created, expiry, user]  (KV store, sharded by key)

 REDIRECT:
 Client ─► LB ─► Redirect svc ─► [Redis cache] ──hit──► HTTP 301/302 → long URL
                       │ miss
                       ▼
                   [URL DB] ─► populate cache
                       └─► click event ─► Kafka ─► Analytics (ClickHouse) ─► dashboards
 Cleanup: TTL / lazy delete + periodic expiry job
```

**Say it like this:** "Creating a link gets a unique ID from a key-generation service or a distributed counter and Base62-encodes it. The mapping goes into a sharded key-value store. Redirects are 100 times more frequent than creates, so they hit Redis first, with the DB as fallback, and return a 301 or 302. Click events are published asynchronously to an analytics pipeline."

### Capacity estimation
| Step | Calculation | Result | Why this assumption |
|---|---|---|---|
| New URLs | 500M/month ÷ 2.6M s | **~200 writes/s** | |
| Read:write | 100:1 | **20k reads/s avg, 60k/s peak** | Links are shared once and clicked many times |
| 5-year volume | 500M × 12 × 5 | **30B URLs** | |
| Record size | ~500 B (key 7 B + long URL ~200 B + metadata + overhead) | **30B × 500 B = 15 TB** | |
| Key length | 62^6 = 56.8B ≥ 30B ✓ (tight); 62^7 = 3.5T | **use 7 chars** | Base62 = a–z, A–Z, 0–9 |
| Reads/day | 20k × 10^5 | 2B | |
| Cache (80/20 rule) | 20% of 2B × 500 B = 1 TB × 20% | **~200 GB → ~4 Redis nodes (+ replicas ≈ 8)** | Hot links get most clicks |
| Click analytics | 2B × 100 B | **200 GB/day** | Async to Kafka → ClickHouse |
| Redirect bandwidth | 60k × 500 B | **~30 MB/s** | Response is only a redirect header |

**What the numbers tell us:** It is **extremely read-heavy** (100:1), so a cache gives most of the win. Storage (15 TB over 5 years) is easy. The real design questions are **unique ID generation without collisions**, **301 vs 302** (301 is cacheable and cheaper but hides clicks from analytics), and the **sharding key**.

---

## 17. Distributed Web Crawler

### Diagram
```
 Seeds ─► [URL Frontier]
            ├─ priority queues (importance, freshness)
            └─ per-host politeness queues (1 request/sec/host)
                   │
                   ▼
          [Fetcher workers] ◄── DNS cache, robots.txt cache
                   │ raw HTML
                   ├──► [Raw store: S3/HDFS] ──► content dedup (SimHash) ──► Indexer (search)
                   ▼
          [Parser / link extractor] ─► URL normalizer ─► URL dedup (Bloom filter + seen-URL DB)
                                                                  │ new URLs
                                                                  ▼
                                                           back into Frontier
 [Metadata DB: url, last_crawled, content_hash, next_crawl] ◄─ re-crawl scheduler feeds Frontier
 Partitioning: hash(hostname) → crawler node (keeps per-host politeness local)
```

**Say it like this:** "The frontier is the brain: priority queues decide what to crawl, and per-host queues enforce politeness. Fetchers download pages and store the raw HTML, then a parser extracts links. Links are normalised and deduped with a Bloom filter before re-entering the frontier, and content is deduped with SimHash. Hosts are partitioned across crawler nodes so politeness stays local."

### Capacity estimation
| Step | Calculation | Result | Why this assumption |
|---|---|---|---|
| Pages/month | assume 1B | 1B ÷ 2.6M s = **~400 pages/s avg, ~800/s peak** | |
| Page size | 100 KB | **40 MB/s ≈ 320 Mbps** | Average HTML document |
| Storage | 1B × 100 KB | **100 TB/month raw**; gzip about 4× → **25 TB/month** | HTML compresses well |
| One year | 25 × 12 | **~300 TB** compressed | |
| In-flight fetches | 400 × 0.5 s | **~200** | Little's Law |
| Parse CPU | 400 × ~10 ms | **~4 cores** | Parsing is cheap |
| Fleet | ~10–20 nodes | | For redundancy, DNS, and JS-rendering share, not raw throughput |
| Politeness | 1 req/s per host | need **≥ 400 distinct hosts active at once** | The frontier must interleave hosts |
| Links found | 50 outlinks per page × 1B | 50B/month ≈ **19k dedup lookups/s** | |
| Bloom filter | 10B URLs seen, 1% false-positive: 9.6 bits each | 10B × 9.6 bits = **~12 GB** | `m/n = -ln(p) / (ln 2)²` |
| Frontier / URL DB | 10B × 100–200 B | **1–2 TB** | |

**What the numbers tell us:** At this scale raw fetching is cheap (about 400 pages/s). **The hard parts are the frontier (politeness plus priority), dedup (Bloom filter in 12 GB instead of a 1+ TB set), and freshness scheduling.** JS-heavy pages are about 10× more expensive and should use a separate headless-browser pool.

---

## 18. Distributed Messaging System (Chat: WhatsApp / Slack)

> Treated as a **chat application**. If you meant a Kafka-style broker, see Sections 2 and 3.

### Diagram
```
 Sender app ══WebSocket══► [Chat Gateway A] ─► Message svc ─► assign msg_id/seq ─► [Message store: Cassandra/HBase]
                                 │                              │
                                 │ who is recipient online on?  ▼
                                 └────────────► [Session registry: user → gateway (Redis, TTL)]
                                                          │
                                  ┌───────────────────────┴───────────────────────┐
                                  ▼ online                                        ▼ offline
              [Chat Gateway B] ══WebSocket══► Recipient app            [Offline inbox] ─► Push (FCM/APNs)
                       ▲        ack ─► delivered / read receipts flow back to sender
 Presence svc (Redis TTL) • Group fan-out workers (Kafka) • Media: presigned upload ─► S3 ─► CDN
 E2EE: clients exchange keys via key server; server only relays ciphertext
```

**Say it like this:** "Users keep a WebSocket to a gateway. A message is persisted with a per-chat sequence ID, then we look up which gateway the recipient is connected to in a session registry and forward it. If they're offline, it goes to an inbox and we send a push. Acks produce delivered and read receipts. Groups fan out through a queue, and media is uploaded directly to object storage."

### Capacity estimation
| Step | Calculation | Result | Why this assumption |
|---|---|---|---|
| DAU | 500M | | |
| Messages | 40 per user per day | **20B/day = 200k/s avg, 600k/s peak** | |
| Message size | ~200 B (100 B text + 100 B metadata) | **4 TB/day** | |
| Retention (if kept) | 4 TB × 365 | **~1.5 PB/yr; × 3 replicas = 4.4 PB** | If messages are deleted after delivery, this drops sharply |
| Media | 5% of messages × 200 KB | 1B × 200 KB = **200 TB/day** | Media dominates bytes |
| Concurrent connections | 20% of DAU online at peak | **~100M** | |
| Gateway servers | 100M ÷ 50k per server | **~2,000** | Conservative with TLS; tuned servers can hold more |
| Presence (naive) | 100M heartbeats ÷ 30 s | **3.3M/s** | Too heavy to write to Redis |

**What the numbers tell us:** Text is small but **connection count is the scaling dimension** (about 100M sockets), so gateways are stateful and horizontally scaled, with a registry to find them. Naive heartbeats would create 3.3M writes/s, so **derive presence from connection open/close events** and TTLs. Media bytes dwarf text, so keep them off the message path.

---

## 19. Auto-Completion (Typeahead)

### Diagram
```
 ONLINE PATH (target: < 100 ms end-to-end)
 Browser (debounce ~150 ms) ─► browser/CDN cache ─► Suggest svc ─► [Redis: top prefixes] ──miss──► [Trie shards: in-memory, by prefix range]
                                                         │ apply blocklist + personalization/locale
                                                         ▼
                                                    top 5–10 suggestions

 OFFLINE PATH (hourly/daily)
 Search logs ─► Kafka ─► Spark/Flink (count, time-decay, trending boost) ─► Trie builder
                                                                               ▼
                                                      snapshot ─► deploy atomically to trie shards
```

**Say it like this:** "Each trie node stores the top-K suggestions for its prefix, so serving is a walk plus a read, not a search. The trie is built offline from aggregated query logs with recency decay and trending boosts, then swapped in atomically. Online, the browser debounces keystrokes, caches responses, and hot prefixes sit in Redis, so only a small fraction of requests reach the trie shards."

### Capacity estimation
| Step | Calculation | Result | Why this assumption |
|---|---|---|---|
| DAU | 100M × 5 searches × 5 suggestion calls per search | **2.5B/day = 25k/s avg, 75k/s peak** | Debounce means roughly 5 requests per typed query |
| Cache hit | 85% (top prefixes dominate) | **backend ≈ 11k/s** | Short prefixes repeat enormously |
| Response | 10 suggestions × ~30 B ≈ 300 B | 75k × 300 B ≈ **22 MB/s** | |
| Distinct queries kept | 100M × avg 20 chars | 2B chars worst case (no sharing) | |
| Trie nodes | assume prefix sharing cuts to ~0.5B nodes × ~60 B | **~30 GB** | Order of magnitude; compact encodings like FST shrink it further |
| Trie servers | 30 GB ÷ ~8–16 GB per shard, with replicas | **~4–6 shards (+ replicas)** | Shard by prefix range or volume |
| Log ingestion | 500M searches × 100 B | **50 GB/day** | Feeds the offline build |

**What the numbers tell us:** Request rate is high but cacheable, and the data is small enough to be **fully in memory**. The design is **precompute, then serve from memory**, with aggressive client and CDN caching. Freshness (trending) is the trade-off, so add a small real-time layer on top of the batch-built trie.

---

## 20. Collaboration System (Google Docs)

### Diagram
```
 Client A ══WS══╗
 Client B ══WS══╬══► Collab Gateway ──route by docId (consistent hash)──► Doc Server (one owner per active doc)
 Client C ══WS══╝                                                           │ OT / CRDT: order + transform ops
                                                                            ├─► broadcast ops to all clients on the doc
                                                                            ├─► Presence / cursors (Redis pub-sub)
                                                                            ├─► Op log (Kafka/Cassandra, append-only)
                                                                            └─► Snapshotter (every N ops) ─► [Doc store: Spanner/Postgres/S3]
 Open a doc: load latest snapshot + replay ops since snapshot
 Side services: ACL/permissions • Comments • Version history (replay ops) • Export (PDF/DOCX) • Search
```

**Say it like this:** "All editors of one document connect through a gateway that routes them to a single doc server, which gives edits a total order. Each edit is a small operation, transformed with OT or merged with a CRDT so everyone converges. Ops are appended to a log and periodically snapshotted. Opening a doc loads the latest snapshot and replays recent ops, and cursors and presence go over a lightweight pub-sub."

### Capacity estimation
| Step | Calculation | Result | Why this assumption |
|---|---|---|---|
| DAU | 50M × 2 edit sessions × 20 min | **concurrent = 50M × 2 × 20 ÷ 1,440 ≈ 1.4M avg, ~4M peak** | |
| Op rate | assume ~1 op/s per active editor (typing in bursts, idle otherwise) | **1.4M ops/s avg, ~4M ops/s peak** | Clients batch keystrokes into ops |
| Ops/day | 50M × 2 × 1,200 s × 1 | **~120B ops/day** | |
| Op size | 100 B | **~12 TB/day** op log (before compaction) | Compact into snapshots |
| Documents | assume 1B × 50 KB | **50 TB; × 3 replicas = 150 TB** | |
| Connections | 4M peak ÷ 40k per gateway | **~100 nodes (plan ~150 with headroom)** | |
| Ops per doc server | 4M ÷ 100 nodes | **~40k ops/s per node** | Fine: transforms are cheap, so bottleneck is I/O |

**What the numbers tell us:** Documents are small but **op throughput and connection count are large**, so the design is driven by **routing every doc to one owner (sticky by docId)** and **log + snapshot** storage. Popular docs with hundreds of editors are the hot-spot case.

---

## 21. ChatGPT-like System (LLM Serving)

> The internals of real products are not public. This is the standard LLM serving architecture, and the GPU numbers are **assumptions** you can swap for your model.

### Diagram
```
 Client ◄══SSE token stream══ Gateway (auth, token-per-minute quota, rate limit, metering)
                                  │
                                  ▼
                            Chat svc ─► [Conversation DB]
                                  │
                                  ▼
          Prompt builder (system prompt + history + RAG chunks + tool results) ◄── [Vector DB] (optional)
                                  │
                                  ▼
                       Safety / moderation (pre)
                                  │
                                  ▼
                 Inference router ─► [Request queue / scheduler, priority tiers]
                                  │
                                  ▼
   GPU cluster: inference replicas (vLLM / TensorRT-LLM)
        • continuous batching     • KV cache (PagedAttention)    • tensor parallel across 4–8 GPUs
                                  │ tokens
                                  ▼
                       Safety (post) ─► stream to client ─► persist conversation + usage metrics
 Tools: function calling, sandboxed code interpreter • Model registry (S3) • Feedback ─► data lake (RLHF/eval)
```

**Say it like this:** "The gateway authenticates and enforces token quotas. The chat service builds a prompt from history and optional retrieved context, runs safety checks, and sends it to a scheduler in front of GPU replicas. Replicas use continuous batching and a paged KV cache to serve many streams per GPU and stream tokens back over SSE. GPUs are the scarce resource, so everything else is designed to keep them saturated."

### Capacity estimation
| Step | Calculation | Result | Why this assumption |
|---|---|---|---|
| Users | 50M DAU × 8 messages/day | **400M requests/day = 4k/s avg, 12k/s peak** | |
| Output tokens | 400 per response | 160B/day = **1.6M tok/s avg, 4.8M tok/s peak** | |
| Input tokens | ~1,500 per request (history + prompt) | 600B/day = **6M tok/s avg** | |
| Prefix-cache hit | assume 70% of input tokens reused | Only 30% need compute: 1.8M avg, **5.4M tok/s peak** | History is re-sent each turn |
| **Model assumption** | 70B-parameter, fp16, 80 layers, 8 KV heads, head dim 128 | | Llama-70B-like (illustrative) |
| KV cache per token | 2 (K,V) × 80 × 8 × 128 × 2 B | **~320 KB/token** | |
| KV per 2k-token sequence | 2,000 × 320 KB | **~650 MB** | |
| 4-GPU replica memory | 4 × 80 GB = 320 GB; weights 140 GB; ~150 GB usable for KV | **~230 concurrent sequences** | Memory is the limit |
| Decode throughput | 230 seqs × ~25 tokens/s ÷ 4 GPUs | **~1,500 tok/s per GPU** | Derived from the line above |
| Decode GPUs | 4.8M ÷ 1,500 | **~3,200** | |
| Prefill throughput | ~140 GFLOP/token ÷ ~400 TFLOP/s effective | ~3,000 tok/s per GPU | Compute-bound |
| Prefill GPUs | 5.4M ÷ 3,000 | **~1,800** | |
| **Total** | 3,200 + 1,800 | **~5,000 GPUs ≈ 625 nodes of 8** | Order of magnitude only |
| Concurrent streams | 12k/s × ~20 s per response (400 tokens at ~20 tok/s) | **~240k open SSE connections** | Little's Law |
| Gateway nodes | 240k ÷ 20k | **~12** | |
| Conversation storage | 400M × ~2.5 KB | **~1 TB/day ≈ 365 TB/yr** | |

**What the numbers tell us:** **GPU memory (KV cache) and GPU count dominate cost**, while the rest of the stack (about 12 gateway nodes, about 1 TB/day storage) is small. Hence the levers are continuous batching, prefix caching, quantization, smaller or mixture-of-experts models, and autoscaling on queue depth. Real systems vary widely, so adjust the per-GPU throughput assumption to your model.

---

## 22. Customer Support Bot

### Diagram
```
 Customer ─► Channel (web widget / WhatsApp / email / app) ─► Chat gateway ─► Orchestrator ─► [Session store: Redis]
                                                                                  │
                              ┌───────────────────────────┬───────────────────────┴──────────────┐
                              ▼                           ▼                                      ▼
                    RAG retrieval: [Vector DB]     LLM service + guardrails              Tool layer (order status,
                    (KB chunks + embeddings)       (PII redaction, grounding,            refund, reset password)
                              ▲                    prompt-injection checks)              scoped auth + confirmation
        KB ingestion: docs ─► chunk ─► embed ─► index
                                                  │
              low confidence / angry sentiment / user asks for human
                                                  ▼
                              Handoff ─► Agent desk (Zendesk/Freshdesk) + ticket with full transcript
 Analytics: CSAT, deflection rate, unanswered questions ─► warehouse ;  Audit logs for compliance
```

**Say it like this:** "The orchestrator takes each customer message, retrieves relevant knowledge-base chunks from a vector DB, and asks the LLM to answer using only that context, behind guardrails for PII and prompt injection. For actions like order status or refunds, it calls internal APIs through a permission-scoped tool layer, with confirmation for risky ones. If confidence is low or the customer is frustrated, it escalates to a human with the full transcript."

### Capacity estimation
| Step | Calculation | Result | Why this assumption |
|---|---|---|---|
| Sessions | assume 200k/day × 6 turns | **1.2M turns/day** | |
| Business-hours concentration | 70% in 8 h: 840k ÷ 28,800 s | **~29 turns/s avg; ~90/s peak** | Support traffic follows working hours |
| LLM latency | ~5 s per turn | concurrent = 90 × 5 = **~450 in-flight LLM calls** | Little's Law |
| Tokens/turn | ~3,000 in (prompt + history + ~5 chunks) / 300 out | **3.6B in / 360M out per day** | |
| KB size | 50k articles × 5 KB | 250 MB text | |
| Chunks | 250 MB ÷ ~1.6 KB (≈400 tokens) | **~156k chunks** | |
| Vectors | 156k × 1,536 dims × 4 B | **~1 GB** (~2 GB with index overhead) | Fits in one vector DB node, so no sharding needed |
| Logs | 1.2M × 2 KB | **2.4 GB/day ≈ 0.9 TB/yr** | |
| Escalation | 20% of sessions = 40k tickets/day × 8 min = ~5,300 agent-hours/day ÷ 6 productive hours | **~900 human agents (across shifts)** | Assumes 20% of chats need a human and 8 min handling time |

**What the numbers tell us:** Infrastructure is **small** (1 GB of vectors, about 450 concurrent LLM calls). The real costs are **LLM tokens** and **human agents**, so the business KPI is the **deflection rate**: every extra 10% of conversations the bot resolves saves about 450 agents in this model. Design effort goes to answer quality, guardrails, and clean handoff.

---

# PART D: Summary Table (what each estimate revealed)

| # | System | Dominant constraint | Design consequence |
|---|---|---|---|
| 1 | Distributed Cache | Memory | Size by RAM, handle hot keys |
| 2 | Messaging Queue | Storage (retention) | Retention is the cost lever; over-provision partitions |
| 3 | Pub-Sub | Fan-out egress | Scale delivery workers separately |
| 4 | Rate Limiter | Redis ops/s | Shard by client key; token bucket to save memory |
| 5 | Blob Store | Storage cost | Erasure coding; metadata service is the critical path |
| 6 | Search | CPU (scatter-gather) | Shard-count trade-off; replicas for read throughput |
| 7 | Logging | Ingest rate | Kafka buffer, tiered storage, sampling |
| 8 | Task Scheduler | Burstiness + reliability | Leases, idempotency, jitter, autoscaled workers |
| 9 | YouTube/Netflix | Egress (≈ 47 PB/day) | CDN is the delivery strategy; async transcoding |
| 10 | Instagram/TikTok | Feed reads + media egress | Fan-out on write (hybrid), feed cache, CDN |
| 11 | Twitter/Reddit | Fan-out writes + timeline memory | Hybrid fan-out, Redis timelines |
| 12 | Google Maps | CDN (tiles) + RAM (graph) + streaming (traffic) | Three different sub-systems |
| 13 | Payments | Correctness, not scale | Idempotency, ledger, state machine, reconciliation |
| 14 | Ride Sharing | Location write rate | Keep live state in memory; geo-shard; avoid double-assignment |
| 15 | Notification | Provider limits + bursts | Per-channel/priority queues, dedupe, vendor failover |
| 16 | URL Shortener | Reads (100:1) | Cache + unique ID generation + 301/302 choice |
| 17 | Web Crawler | Frontier + dedup, not fetching | Politeness queues, Bloom filter, SimHash |
| 18 | Chat | Connection count (~100M) | Stateful gateways + session registry; derive presence |
| 19 | Autocomplete | Latency | Precompute trie; in-memory; layered caching |
| 20 | Google Docs | Ops throughput + routing | One owner per doc; log + snapshot |
| 21 | ChatGPT | GPU memory/count | Continuous batching, KV cache, prefix caching |
| 22 | Support Bot | LLM tokens + human agents | RAG, guardrails, deflection rate, handoff |

---

## Final checklist before you walk into the interview

- [ ] Draw the **common diagram** first (Part A), then add the system-specific boxes.
- [ ] State **DAU and actions/user** out loud, then compute QPS with `÷ 10^5`.
- [ ] Always give **average and peak** (peak = 2–3×, or 10× for bursty systems).
- [ ] Do **storage × replication**, and **bandwidth = QPS × size**.
- [ ] Say which resource is the bottleneck: **memory / storage / CPU / network / GPU / connections / correctness**.
- [ ] Finish with: **"So the design implication is ___."** This is what separates a good answer from a recited one.
