# HLD Interview Cheat Sheet: Components for 22 Systems

**How to use this:** Part 1 covers components that appear in almost every system. Part 2 covers what is special about each of the 22 systems. Part 3 is a quick matrix so you can see at a glance which common components each system needs.

Legend for the matrix: ✔ = needed, ◐ = optional/depends, – = not needed.

---

## 0. The Mental Framework (use it for every system)

Every HLD answer can be walked through the same 6 layers. If you can name something in each layer, you can design a minimal system.

```
Client → Edge → Service → Data → Async → Observability
```

| Layer | Question it answers | Typical pieces |
|---|---|---|
| Client | Who calls us, over what protocol? | Web/mobile app, REST, gRPC, WebSocket, SSE |
| Edge | How does traffic reach us safely? | DNS, CDN, WAF, Load Balancer, API Gateway |
| Service | Where is the business logic? | Stateless services, service discovery |
| Data | Where does state live? | SQL/NoSQL, cache, blob store, search index |
| Async | What can be done later? | Queue/stream, workers, schedulers |
| Observability | How do we know it works? | Logs, metrics, traces, alerts |

**Interview flow (45 min):**
1. Clarify functional requirements (3–5 core features only)
2. Non-functional requirements: scale, latency, availability vs consistency (CAP), durability
3. Back-of-envelope estimation: QPS, storage, bandwidth, read:write ratio
4. APIs (3–5 endpoints)
5. Data model + DB choice with reason
6. High-level diagram (use Part 1 baseline plus Part 2 specifics)
7. Deep dive on 1–2 hard parts (the "special problem" in each Part 2 section)
8. Bottlenecks, failure modes, trade-offs, and what you would improve

---

# PART 1: COMMON COMPONENTS (used in almost every system)

## 1.1 Edge / Traffic Layer

### 1. DNS
- **What it does:** Translates a domain name to IP addresses. Can do geo-routing, latency-based routing, and health-check failover across regions.
- **Real-life examples:** AWS Route 53, Cloudflare DNS, Google Cloud DNS, NS1.
- **Interview line:** "Route 53 with latency-based routing sends the user to the nearest region."

### 2. CDN (Content Delivery Network)
- **What it does:** Caches static content (JS/CSS/images/video) at edge locations close to users. This cuts latency and offloads origin servers. Even text-heavy apps use it for static assets.
- **Real-life examples:** AWS CloudFront, Cloudflare, Akamai, Fastly, Google Cloud CDN, Netflix Open Connect (Netflix's own CDN).
- **Interview line:** Push CDN for rarely changing content, pull CDN for long-tail content.

### 3. Load Balancer (L4 / L7)
- **What it does:** Distributes incoming requests across multiple servers, runs health checks, and removes unhealthy nodes.
  - **L4** (TCP/UDP): fast, no content awareness.
  - **L7** (HTTP): routes by path, header, or cookie, and can terminate TLS.
  - Algorithms: round robin, least connections, IP hash, weighted, consistent hashing.
- **Real-life examples:** AWS ALB (L7) / NLB (L4), Google Cloud Load Balancing, NGINX, HAProxy, Envoy, F5 BIG-IP, Azure Load Balancer.
- **Interview line:** LB removes the single point of failure and enables horizontal scaling. The LB itself must be redundant (active-passive or active-active).

### 4. Reverse Proxy
- **What it does:** Sits in front of servers and handles TLS termination, compression, static file serving, response caching, request buffering, and hiding backend topology. An LB is a specialised reverse proxy.
- **Real-life examples:** NGINX, HAProxy, Envoy, Traefik, Apache httpd, Varnish (caching proxy).

### 5. API Gateway
- **What it does:** Single entry point for clients. Handles routing to microservices, authentication, rate limiting, request/response transformation, API versioning, and aggregation.
- **Real-life examples:** AWS API Gateway, Kong, Apigee, Spring Cloud Gateway (Java), Netflix Zuul, Azure API Management, Tyk.
- **Difference from LB:** The LB spreads load across *identical* servers. The gateway routes to *different* services and applies cross-cutting policies.

### 6. WAF and DDoS Protection
- **What it does:** Blocks malicious traffic such as SQL injection, XSS, bot traffic, and volumetric attacks.
- **Real-life examples:** AWS WAF + AWS Shield, Cloudflare WAF, Akamai Kona, Imperva.

### 7. Authentication and Authorization
- **What it does:** Verifies who the caller is (authn) and what they can do (authz). Uses OAuth2/OIDC, JWT access tokens, API keys, mTLS between services, and RBAC/ABAC.
- **Real-life examples:** Auth0, Okta, Keycloak, AWS Cognito, Firebase Auth, Spring Security (Java), Google Identity.

### 8. Rate Limiter (as a cross-cutting guard)
- **What it does:** Protects services from abuse and overload (HTTP 429). Usually enforced at the gateway with counters in Redis. Algorithms: token bucket, leaky bucket, fixed/sliding window.
- **Real-life examples:** Envoy rate limit service, Kong rate-limiting plugin, AWS API Gateway throttling, Bucket4j and Resilience4j (Java libraries), NGINX `limit_req`.

---

## 1.2 Compute / Service Layer

### 9. Stateless Application Servers + Autoscaling
- **What it does:** Business logic servers that keep no session state locally (state goes to Redis/DB). Because they are stateless, any server can handle any request, so you scale horizontally by adding instances.
- **Real-life examples:** Spring Boot services in Docker on Kubernetes, AWS EC2 Auto Scaling Groups, AWS ECS/Fargate, Kubernetes Horizontal Pod Autoscaler, AWS Lambda for serverless.

### 10. Service Discovery and Configuration
- **What it does:** Services find each other without hardcoded IPs. Centralised config and feature flags avoid redeploys.
- **Real-life examples:** Netflix Eureka, HashiCorp Consul, Kubernetes DNS/Services, ZooKeeper, etcd, Spring Cloud Config, AWS Cloud Map, LaunchDarkly (feature flags).

### 11. Service Mesh (for microservices at scale)
- **What it does:** A sidecar proxy per service handles mTLS, retries, timeouts, traffic shifting, and telemetry without changing app code.
- **Real-life examples:** Istio, Linkerd, Consul Connect, AWS App Mesh.

### 12. Resilience Patterns
- **What it does:** Keep one failing dependency from taking everything down.
  - **Timeouts** on every remote call
  - **Retries with exponential backoff + jitter**
  - **Circuit breaker** (stop calling a failing service)
  - **Bulkhead** (isolate thread pools)
  - **Idempotency keys** (safe retries)
  - **Graceful degradation / fallbacks**
- **Real-life examples:** Resilience4j (Java), Netflix Hystrix (maintenance mode), Istio retries/circuit breaking, Polly (.NET).

### 13. Unique ID Generation
- **What it does:** Generates globally unique IDs without a central bottleneck. Options: UUID, ULID, DB auto-increment, Redis INCR, ticket servers, and **Snowflake-style** (timestamp + machine ID + sequence, roughly time-sortable).
- **Real-life examples:** Twitter Snowflake, Instagram's ID scheme (Postgres-based Snowflake variant), Flickr Ticket Server, MongoDB ObjectId, Sonyflake.

### 14. Distributed Coordination (Leader Election / Locks)
- **What it does:** Picks a single leader, manages distributed locks, and stores small critical config consistently using consensus (Paxos/Raft/ZAB).
- **Real-life examples:** Apache ZooKeeper, etcd, HashiCorp Consul, Redis Redlock (debated for strict correctness), Google Chubby.

---

## 1.3 Data Layer

### 15. Relational Database (SQL)
- **When to use:** Structured data, ACID transactions, joins, strong consistency (payments, orders, user accounts).
- **Scaling path:** vertical scaling → read replicas → sharding.
- **Real-life examples:** MySQL, PostgreSQL, AWS Aurora, Google Cloud Spanner (globally distributed SQL), CockroachDB, Oracle.

### 16. NoSQL Databases (pick by access pattern)
| Type | Use when | Real-life examples |
|---|---|---|
| Key-Value | Simple lookups by key, huge scale | DynamoDB, Redis, Riak |
| Wide-Column | Massive writes, time-series-like, tunable consistency | Cassandra, HBase, Bigtable, ScyllaDB |
| Document | Flexible schema, nested JSON | MongoDB, Couchbase, Firestore |
| Graph | Relationship traversals (social graph) | Neo4j, Amazon Neptune, JanusGraph |
| Time-series | Metrics/events by time | InfluxDB, TimescaleDB, Prometheus TSDB |
| Vector | Embedding similarity search | Pinecone, Milvus, Weaviate, pgvector, FAISS |

### 17. Replication and Sharding (Partitioning)
- **Replication:** copies of data for availability and read scaling (leader-follower, multi-leader, leaderless/quorum).
- **Sharding:** splits data across nodes by hash, range, or directory. **Consistent hashing** minimises data movement when nodes join or leave.
- **Real-life examples:** MySQL replication, Vitess (sharding layer for MySQL, born at YouTube), Citus (Postgres), Cassandra ring, DynamoDB partitions, MongoDB sharding.

### 18. Cache
- **What it does:** Keeps hot data in memory to cut latency and DB load.
  - Patterns: **cache-aside**, write-through, write-back, refresh-ahead
  - Eviction: LRU, LFU, TTL
  - Problems to mention: cache stampede, hot keys, stale data/invalidation
- **Real-life examples:** Redis, Memcached, AWS ElastiCache, Hazelcast, Netflix EVCache, Caffeine/Guava (in-process cache in Java).

### 19. Blob / Object Storage
- **What it does:** Stores large unstructured files (images, video, backups, logs) cheaply and durably. Keep only the *URL/key* in the DB.
- **Real-life examples:** AWS S3, Google Cloud Storage, Azure Blob Storage, MinIO, Ceph.

### 20. Search Index
- **What it does:** Full-text and faceted search using an inverted index. The DB is the source of truth, and the index is a derived copy kept in sync (often via CDC or a queue).
- **Real-life examples:** Elasticsearch, OpenSearch, Apache Solr, Algolia, Typesense.

### 21. Data Warehouse / Batch and Stream Analytics
- **What it does:** Offline analytics, reporting, and ML feature generation, separate from the serving DB.
- **Real-life examples:** Hadoop/HDFS, Apache Spark, Apache Flink, Apache Hive, BigQuery, Snowflake, AWS Redshift, ClickHouse, Apache Druid.

---

## 1.4 Async / Messaging Layer

### 22. Message Queue / Event Streaming
- **What it does:** Decouples producers from consumers, absorbs traffic spikes, and enables retries and async processing.
  - **Queue** (task distribution, a message is consumed once): SQS, RabbitMQ, ActiveMQ
  - **Log/stream** (replayable, multiple consumer groups): Kafka, Pulsar, AWS Kinesis, Redpanda
- **Interview line:** "I'll put a queue between the API and the slow work so the API can reply quickly and workers scale independently."

### 23. Background Workers / Job Processors
- **What it does:** Consume from queues and do heavy or slow work (video encoding, emails, report generation).
- **Real-life examples:** Spring Batch / `@Async` / Spring `@KafkaListener` (Java), AWS Lambda, Celery, Sidekiq, Kubernetes Jobs.

### 24. Dead Letter Queue (DLQ) and Retry
- **What it does:** Messages that keep failing go to a DLQ for inspection instead of blocking the queue.
- **Real-life examples:** AWS SQS DLQ, RabbitMQ dead-letter exchange, Kafka retry topics, Spring Cloud Stream DLQ.

### 25. Real-Time Push Channels
- **What it does:** Server-to-client updates without polling.
  - **WebSocket:** bidirectional (chat, collaboration, ride tracking)
  - **SSE:** server to client only (token streaming, live feeds)
  - **Long polling:** fallback
  - **Mobile push:** when the app is closed
- **Real-life examples:** Netty / Spring WebSocket / STOMP (Java), Socket.IO, AWS API Gateway WebSocket, Firebase Cloud Messaging (FCM), Apple Push Notification service (APNs).

---

## 1.5 Observability and Operations

### 26. Centralised Logging
- **Real-life examples:** ELK/EFK stack (Elasticsearch + Logstash/Fluentd + Kibana), Splunk, Grafana Loki, AWS CloudWatch Logs, Datadog Logs.

### 27. Metrics and Monitoring
- **What it does:** Tracks latency (p50/p95/p99), throughput, error rate, saturation (the "golden signals").
- **Real-life examples:** Prometheus + Grafana, Datadog, New Relic, AWS CloudWatch, Micrometer (Java metrics facade).

### 28. Distributed Tracing
- **What it does:** Follows one request across many services using a trace ID.
- **Real-life examples:** OpenTelemetry, Jaeger, Zipkin, AWS X-Ray, Spring Cloud Sleuth / Micrometer Tracing.

### 29. Alerting and On-Call
- **Real-life examples:** PagerDuty, Opsgenie, Alertmanager (Prometheus), Grafana Alerting.

### 30. Security Plumbing
- **What it does:** Secrets, encryption keys, and encryption at rest and in transit.
- **Real-life examples:** HashiCorp Vault, AWS KMS, AWS Secrets Manager, AWS CloudHSM, TLS via cert-manager / Let's Encrypt.

### 31. Deployment Infrastructure
- **What it does:** Containers, orchestration, CI/CD, multi-AZ and multi-region deployment, blue-green and canary releases.
- **Real-life examples:** Docker, Kubernetes, Terraform, Jenkins, GitHub Actions, ArgoCD, Spinnaker.

---

## 1.6 The Minimal Baseline Architecture (start every design here)

```
                         ┌───────────┐
   Client ──► DNS ──►    │    CDN    │ (static content)
      │                  └───────────┘
      ▼
 [WAF / DDoS] ──► [Load Balancer] ──► [API Gateway: auth, rate limit, routing]
                                              │
                         ┌────────────────────┼─────────────────────┐
                         ▼                    ▼                     ▼
                  [Service A]           [Service B]           [Service C]   (stateless, autoscaled)
                         │                    │                     │
              ┌──────────┼──────────┐         │                     │
              ▼          ▼          ▼         ▼                     ▼
          [Cache]   [Primary DB]  [Blob]   [Queue/Stream] ──► [Workers] ──► [Search index / Analytics]
                     │  replicas                                │
                     ▼                                          ▼
              [Read replicas / shards]                    [DLQ + retries]

  Cross-cutting: Logging • Metrics • Tracing • Alerts • Service discovery • Secrets • CI/CD
```

**Say this out loud in the interview:** "Clients hit a CDN and load balancer, then an API gateway doing auth and rate limiting, then stateless services. State lives in a DB with a cache in front. Heavy work goes through a queue to workers. Everything is observable."

---

# PART 2: APPLICATION-SPECIFIC COMPONENTS

Each section has: the **special problem**, the **components unique to this system** (with real-life examples), a **minimal flow**, and **trade-offs to mention**. Assume the Part 1 baseline (LB, gateway, cache, DB, monitoring) is also present unless stated otherwise.

---

## 1. Distributed Cache (Redis / Memcached-like)

**Special problem:** Spread data across many nodes with sub-millisecond reads, survive node failures, and avoid hot spots.

| Component | What it does | Real-life examples |
|---|---|---|
| Cache client / smart client | Computes which node owns a key, handles retries and failover | Jedis, Lettuce, Redisson (Java), Memcached ketama client |
| Proxy layer (optional) | Routes requests so clients stay dumb | Twemproxy, Envoy Redis proxy, Redis Cluster-aware proxies |
| Consistent hashing ring / hash slots | Maps keys to nodes with minimal reshuffling when scaling | Redis Cluster (16384 hash slots), Dynamo-style ring, Memcached ketama |
| Cache nodes | In-memory hash table storing key to value | Redis, Memcached, Hazelcast, Apache Ignite |
| Replication (leader to replicas) | Failover and read scaling | Redis replication, Redis Sentinel (failover) |
| Failure detection / membership | Detects dead nodes, promotes replicas | Redis Cluster gossip bus, Sentinel, Consul |
| Eviction policy engine | Decides what to drop when memory is full | LRU, LFU (Redis approximated LRU/LFU), Caffeine's W-TinyLFU |
| TTL / expiry manager | Lazy plus periodic deletion of expired keys | Redis active expiry cycle |
| Persistence (optional) | Survive restarts | Redis RDB snapshots, AOF log |
| Write policy | How cache and DB stay in sync | Cache-aside, write-through, write-back, refresh-ahead |
| Hot key / stampede protection | Avoid thundering herd | Request coalescing (singleflight), mutex on miss, probabilistic early refresh, local L1 cache for hot keys |

**Minimal flow:** Client library hashes the key, finds the owner node, GET/SET. On miss, the app reads the DB and populates the cache with a TTL.
**Trade-offs:** Consistency vs latency (stale reads), memory cost, rebalancing during scale-out, hot keys, replication lag losing writes on failover.

---

## 2. Distributed Messaging Queue (Kafka / SQS / RabbitMQ-like)

**Special problem:** Durable, ordered (or at least reliable), high-throughput message delivery with horizontal scaling.

| Component | What it does | Real-life examples |
|---|---|---|
| Producer client + partitioner | Sends messages, picks the partition by key (preserves per-key order) | Kafka Producer API, Spring Kafka `KafkaTemplate`, SQS SDK |
| Broker nodes | Receive, store, serve messages | Kafka brokers, RabbitMQ nodes, SQS fleet |
| Topics / partitions / queues | Unit of parallelism and ordering | Kafka partitions, SQS FIFO message groups |
| Append-only commit log + segment files + index | Sequential disk writes for speed and durability | Kafka log segments, Apache BookKeeper |
| Replication (leader, followers, ISR) | Durability when a broker dies | Kafka ISR, RabbitMQ quorum queues |
| Metadata / controller service | Tracks partition leaders and cluster membership | ZooKeeper (older Kafka), KRaft (newer Kafka), etcd |
| Consumer groups + offset manager | Each partition read by one consumer in a group, progress tracked | Kafka `__consumer_offsets`, SQS visibility timeout and delete |
| Ack / nack, visibility timeout | Redelivery if a consumer crashes | SQS visibility timeout, RabbitMQ acks |
| DLQ and retry/delay queues | Poison message handling | SQS DLQ, RabbitMQ DLX, Kafka retry topics |
| Delivery semantics | At-most-once / at-least-once / exactly-once | Kafka idempotent producer + transactions |
| Retention and compaction | Time/size-based delete or keep latest per key | Kafka retention, log compaction |
| Schema registry | Enforces message schema evolution | Confluent Schema Registry (Avro/Protobuf) |

**Minimal flow:** Producer → partitioner → leader broker (replicated) → consumer group pulls and commits offset.
**Trade-offs:** Ordering vs parallelism (per-partition only), at-least-once means consumers must be idempotent, partition count is hard to change, push vs pull.

---

## 3. Distributed Pub-Sub Model

**Special problem:** One message goes to many independent subscribers (fan-out), each with its own delivery state.

| Component | What it does | Real-life examples |
|---|---|---|
| Topic manager | Creates and manages topics | Google Pub/Sub topics, SNS topics, Kafka topics |
| Subscription manager | Each subscription tracks its own cursor/backlog | Google Pub/Sub subscriptions, Kafka consumer groups, Pulsar subscriptions |
| Fan-out service | Copies/routes a message to every subscription | SNS → multiple SQS queues (the classic fan-out pattern) |
| Per-subscription message store / cursor | Independent progress, so slow subscribers don't block fast ones | Pulsar cursors on BookKeeper, Kafka offsets |
| Push vs pull delivery | Push to HTTP endpoints (webhooks) or consumers pull | Pub/Sub push subscription, SNS HTTP endpoints, Kafka pull |
| Filtering | Subscribers only get matching messages | SNS filter policies, Pub/Sub filters, RabbitMQ topic exchange |
| Ordering keys | Ordered delivery per key | Pub/Sub ordering keys, Kafka partition key |
| Retry with backoff + DLQ | Handles unreachable subscribers | Pub/Sub dead-letter topics, SNS DLQ |
| Replay / seek | Re-read old messages | Pub/Sub seek, Kafka offset reset |
| Ephemeral pub-sub | Fire-and-forget, no durability | Redis Pub/Sub, NATS core |

**Minimal flow:** Publisher → topic → fan-out → N subscription queues → each subscriber consumes independently.
**Trade-offs:** Durable (Kafka/Pub-Sub) vs ephemeral (Redis Pub/Sub). At-least-once means duplicates. Push is simple but needs backoff, pull gives flow control.
**Queue vs Pub-Sub in one line:** Queue = each message processed by one consumer. Pub-Sub = each message delivered to every subscriber.

---

## 4. Distributed Rate Limiter

**Special problem:** Enforce limits consistently across many gateway nodes with very low added latency.

| Component | What it does | Real-life examples |
|---|---|---|
| Rule / config store | Limits per user, API key, IP, endpoint, tier | etcd, Consul, DB; Envoy ratelimit YAML config |
| Limiter middleware / sidecar | Intercepts the request, checks the counter | Envoy, NGINX `limit_req`, Kong plugin, Spring Cloud Gateway `RequestRateLimiter`, Bucket4j, Resilience4j |
| Algorithm | Token bucket, leaky bucket, fixed window, sliding window log, sliding window counter | Stripe uses token-bucket style limiters; Cloudflare uses sliding window counters |
| Central counter store | Shared counters across nodes, atomic updates | Redis with Lua scripts or `INCR` + `EXPIRE`, redis-cell |
| Client identifier | Decides *who* is limited | API key, user ID, IP, JWT subject |
| Local counters + periodic sync (optional) | Reduces Redis round trips at the cost of accuracy | In-memory token buckets syncing to Redis |
| Response contract | Tells clients what happened | HTTP 429, `Retry-After`, `X-RateLimit-Limit/Remaining/Reset` |
| Race-condition handling | Avoid check-then-set races | Redis Lua scripts, atomic ops |
| Fail-open vs fail-closed policy | What happens if Redis is down | Usually fail-open for non-critical APIs |

**Minimal flow:** Request → gateway middleware → Redis atomic check → allow or 429.
**Trade-offs:** Accuracy vs latency (central vs local counters), fixed window allows boundary bursts, sliding window costs more memory, Redis is a dependency, so decide fail-open or fail-closed.

---

## 5. Distributed Blob Store (S3 / GCS-like)

**Special problem:** Store billions of large objects with extreme durability (11 nines) cheaply.

| Component | What it does | Real-life examples |
|---|---|---|
| Front-end REST API | PUT / GET / DELETE / LIST by bucket and key | S3 API, GCS JSON API, MinIO |
| Auth and bucket policies | Access control, presigned URLs | AWS IAM + bucket policies, GCS IAM, SAS tokens (Azure) |
| Metadata service | Maps bucket+key to chunk locations, size, version, ACL | DynamoDB-like KV store, Spanner (GCS), HDFS NameNode, GFS master |
| Chunking | Split large objects into fixed-size chunks and upload in parallel | S3 Multipart Upload, GFS 64 MB chunks, HDFS blocks |
| Storage / data nodes | Hold the actual chunks on disks | HDFS DataNodes, GFS chunkservers, Ceph OSDs |
| Replication vs erasure coding | 3x copies (simple, fast reads) or Reed-Solomon (cheaper storage, repair cost) | S3 and GCS use erasure coding at scale; HDFS 3x replication or EC |
| Placement service | Rack/AZ/region-aware chunk placement | Ceph CRUSH map, Swift ring, HDFS rack awareness |
| Checksums and integrity scrubber | Detects bit rot, triggers repair | S3 checksums, HDFS block scanner |
| Heartbeats and re-replication | Detects dead nodes and rebuilds lost chunks | HDFS NameNode heartbeats |
| Garbage collector | Cleans deleted or orphaned chunks | GFS lazy GC |
| Versioning and lifecycle policies | Keep versions, tier to cold storage, expire | S3 Versioning, S3 Lifecycle → Glacier |
| Presigned URLs and CDN | Client uploads or downloads directly, bypassing app servers | S3 presigned URLs + CloudFront |

**Minimal flow:** Client → API/auth → metadata service allocates chunk locations → client or API streams chunks to data nodes (replicated) → metadata commit → ack.
**Trade-offs:** Replication vs erasure coding (cost vs repair speed), metadata service is the bottleneck so shard it, strong vs eventual consistency on list operations, small-object problem (Facebook built Haystack to pack many small photos into big files).

---

## 6. Distributed Search (Elasticsearch / Google Search-like)

**Special problem:** Fast relevance-ranked full-text search over massive, constantly changing data.

| Component | What it does | Real-life examples |
|---|---|---|
| Ingestion pipeline | Gets data from sources into the index | Logstash, Kafka Connect, Debezium (CDC from DB), Apache Nutch (crawler) |
| Analyzer / tokenizer | Lowercasing, stemming, stop-words, synonyms, n-grams | Lucene analyzers, Elasticsearch analysis chain |
| Inverted index | Term to list of document IDs (postings list) | Apache Lucene (inside Elasticsearch and Solr) |
| Shards and replicas | Horizontal split of the index plus copies for HA | Elasticsearch primary/replica shards, Solr cores |
| Coordinating node / query router | Receives the query, fans out to shards, merges results | Elasticsearch coordinating node (scatter-gather) |
| Master / cluster state manager | Tracks shard allocation and cluster health | Elasticsearch master node, ZooKeeper (Solr Cloud) |
| Ranking and scoring | Relevance: TF-IDF, **BM25**, then ML re-ranking | Lucene BM25, Learning-to-Rank plugins |
| Segment merge and near-real-time refresh | Immutable segments merged in the background, searchable within ~1s | Lucene segments, ES refresh interval |
| Suggestions and spell check | "Did you mean", autocomplete | ES suggesters, Algolia |
| Facets and aggregations | Filters and counts by category | ES aggregations, Solr facets |
| Index sync from the primary DB | Keep the index fresh | CDC (Debezium) → Kafka → indexer, dual writes (risky) |

**Minimal flow:** DB change → Kafka → indexer → sharded inverted index. Query → coordinator → scatter to shards → gather top-K → merge → return.
**Trade-offs:** Index freshness vs indexing cost, shard count is hard to change later, deep pagination is expensive (use `search_after`), the search index is not a source of truth.

---

## 7. Distributed Logging System

**Special problem:** Collect, ship, store, and query terabytes of logs from thousands of machines without losing them or hurting the apps.

| Component | What it does | Real-life examples |
|---|---|---|
| Log generation (structured logs) | JSON logs with trace/correlation IDs | Logback / Log4j2 + MDC (Java), OpenTelemetry |
| Log agents / shippers | Run on each host and tail files | Filebeat, Fluent Bit, Fluentd, Promtail, Vector |
| Buffer / transport layer | Absorbs spikes and decouples producers from storage | Apache Kafka, AWS Kinesis |
| Aggregator / processor | Parse, enrich, filter, mask PII | Logstash (grok), Fluentd, Vector |
| Hot storage and index | Fast search over recent logs | Elasticsearch / OpenSearch, Grafana Loki, ClickHouse |
| Cold storage | Cheap long-term retention | S3, HDFS, Glacier |
| Retention and tiering policies | Hot to warm to cold to delete | Elasticsearch ILM, S3 Lifecycle |
| Query and visualisation | Search UI and dashboards | Kibana, Grafana, Splunk |
| Alerting on logs | Trigger on patterns or error rates | ElastAlert, Grafana Alerts, Splunk Alerts |
| Sampling, rate control, multi-tenancy | Protect the pipeline from noisy services | Fluentd throttling, per-tenant quotas |

**Minimal flow:** App → agent → Kafka → processor → Elasticsearch (hot) and S3 (cold) → Kibana.
**Trade-offs:** Cost (indexing everything is expensive; Loki indexes only labels), delivery guarantee (at-least-once means dupes, dropping vs blocking when overloaded), PII compliance, query latency vs retention.

---

## 8. Distributed Task Scheduler (Cron at scale)

**Special problem:** Run millions of jobs *at the right time*, exactly once in effect, and survive node failures.

| Component | What it does | Real-life examples |
|---|---|---|
| Job definition API and store | CRUD for jobs (schedule, payload, retries, owner) | MySQL / PostgreSQL / Cassandra |
| Cron parser / trigger calculator | Computes the next fire time | Quartz `CronExpression` (Java), Spring `@Scheduled` |
| Due-job finder | Finds jobs whose time has come | Time-bucketed DB polling (`WHERE next_run <= now`), Redis ZSET (score = timestamp), hierarchical timing wheel, delay queues |
| Leader election / partition ownership | Prevent two schedulers from firing the same job | ZooKeeper, etcd, ShedLock (Java), Quartz clustered JDBC JobStore |
| Dispatch queue | Hands due jobs to workers | Kafka, SQS, RabbitMQ |
| Worker pool / executors | Run the job | Kubernetes Jobs, Celery workers, Temporal workers |
| Lease / heartbeat / visibility timeout | Detect worker crashes and reassign | SQS visibility timeout, DB lease column |
| Retry with backoff, DLQ | Failed job handling | Temporal retry policies, Airflow retries |
| Idempotency | At-least-once execution means jobs must be safe to repeat | Idempotency keys, dedupe table |
| Workflow / DAG engine (advanced) | Job dependencies | Apache Airflow, Temporal, Netflix Conductor, Uber Cadence |
| Execution history, status and UI | Observability and audit | Airflow UI, Quartz history tables |
| Priority and concurrency control | Fairness between tenants | Priority queues, per-tenant limits |

**Minimal flow:** Jobs in DB → scheduler (leader or sharded) finds due jobs → pushes to queue → workers execute with lease → update status → compute next run.
**Trade-offs:** Exactly-once is practically at-least-once plus idempotency, polling interval vs DB load, clock skew, thundering herd at round times (like 00:00), long-running jobs need heartbeats.

---

## 9. Video Streaming Platform (YouTube / Netflix)

**Special problem:** Ingest huge uploads, convert to many formats, and deliver smooth playback on any network or device worldwide.

| Component | What it does | Real-life examples |
|---|---|---|
| Resumable / chunked upload service | Reliable upload of large files, direct to storage | Presigned S3 multipart upload, tus protocol, YouTube resumable uploads |
| Raw video storage | Stores the original file | AWS S3, Google Cloud Storage |
| Workflow orchestrator and queue | Triggers and coordinates the processing steps | Kafka, SQS, AWS Step Functions, Temporal, Netflix Conductor |
| Video splitter | Splits into GOP-aligned chunks for parallel encoding | FFmpeg segmenter, custom DAG stages |
| **Encoder / Transcoder** | Converts to multiple codecs, resolutions, and bitrates | FFmpeg, AWS Elemental MediaConvert, Netflix per-title encoding |
| Codecs | Compress video: H.264/AVC, H.265/HEVC, VP9, AV1; audio: AAC, Opus | Used by YouTube and Netflix |
| **Bitrate ladder** | Same video at 240p, 360p, 480p, 720p, 1080p, 4K | Netflix per-title / per-shot ladders |
| **Packager** | Wraps encoded chunks plus a manifest for streaming protocols | HLS (`.m3u8`), MPEG-DASH (`.mpd`), CMAF; Shaka Packager, Bento4 |
| Thumbnail / preview generator | Poster frames and sprite sheets | FFmpeg, ML for best-frame selection |
| DRM / encryption | Protect premium content | Widevine, FairPlay, PlayReady |
| Content moderation and copyright detection | Blocks policy or copyright violations | YouTube Content ID, ML classifiers |
| Metadata DB | Title, description, owner, status, available renditions | MySQL / Vitess (YouTube), Cassandra |
| **CDN (very critical)** | Serves video chunks from edge | Netflix Open Connect (appliances inside ISPs), Akamai, CloudFront, Google Global Cache |
| **Adaptive Bitrate (ABR) player** | Switches quality chunk by chunk based on bandwidth | ExoPlayer (Android), AVPlayer (iOS), Shaka Player, hls.js, dash.js |
| Recommendation system | Candidate generation then ranking | ML pipelines on Spark/Flink + feature store; Netflix recs |
| View counts and analytics pipeline | Counts views and watch time at scale | Kafka + Flink/Spark → ClickHouse/Druid, batched counter updates |
| Comments, likes, subscriptions | Standard CRUD, read-heavy with counters | Sharded SQL / Cassandra + Redis counters |
| Search | Title/tags search | Elasticsearch |
| Netflix extras (good to name-drop) | Edge gateway, service discovery, caching | Zuul, Eureka, EVCache, Cassandra |

**Minimal flow:** Upload → raw store → queue → split → parallel transcode into the bitrate ladder → package HLS/DASH + manifest → store in blob → push/pull to CDN → player fetches manifest and adaptively picks chunks.
**Trade-offs:** Storage cost of many renditions (encode popular videos fully, long-tail lazily), encoding latency vs quality, CDN cache hit ratio, cost of egress, live streaming needs low-latency chunking (LL-HLS) and a separate ingest path (RTMP/SRT/WebRTC).

---

## 10. Video + Image Intensive Platforms (Instagram / TikTok)

**Special problem:** Heavy media plus a *personalised feed* at huge scale. Short videos need near-instant start.

| Component | What it does | Real-life examples |
|---|---|---|
| Media upload service | Presigned upload straight to blob | S3 presigned URLs |
| Image processing pipeline | Resize, crop, compress, convert to WebP/AVIF, multiple sizes | Thumbor, imgix, Cloudinary, AWS Lambda, Facebook Haystack-style photo store |
| Short-video transcoding | Same as Section 9 but optimised for short clips and fast availability | FFmpeg, hardware encoders |
| CDN | Images and video from the edge | CloudFront, Akamai, Fastly, Cloudflare |
| **Feed generation service** | Builds each user's home feed | See fan-out below |
| **Fan-out on write (push)** | On post, push the post ID into followers' feed caches | Redis sorted sets/lists per user |
| **Fan-out on read (pull)** | Merge posts of followees at read time | Used for celebrity accounts |
| **Hybrid fan-out** | Push for normal users, pull for celebrities (the "Celebrity problem") | Twitter and Instagram-style approach |
| Feed cache | Pre-computed feed lists | Redis, Memcached |
| Social graph store | Follow/follower relationships | Facebook TAO, sharded MySQL, Neo4j, FlockDB (Twitter's), Neptune |
| Ranking / recommendation engine | ML-based ordering and "For You" discovery (TikTok is mostly interest-based, not follow-based) | Two-tower retrieval + ranking models, TensorFlow Serving, feature store (Feast) |
| Stories (ephemeral content) | 24h TTL content | Cassandra TTL, Redis TTL |
| Like / comment counters | High-write counters | Redis INCR, sharded counters, Kafka aggregation to DB |
| Explore, hashtags, search | Discovery | Elasticsearch, inverted index on tags |
| Moderation | Detect nudity, violence, spam | ML classifiers, AWS Rekognition, human review queues |
| Client-side prefetch | Preload the next videos for instant swipe | Player-side buffering (TikTok-style) |

**Minimal flow:** Upload → blob → async processing (resize/transcode) → metadata DB → fan-out service updates feed caches → client fetches feed (IDs) → hydrates post metadata → media from CDN.
**Trade-offs:** Fan-out write amplification vs read latency, celebrity hot keys, feed freshness vs ranking cost, media storage cost, cursor-based pagination for infinite scroll.

---

## 11. Text-Heavy Platforms (Twitter / Reddit)

**Special problem:** Massive read-heavy timelines, real-time trends and search, voting and nested comments.

| Component | What it does | Real-life examples |
|---|---|---|
| Post / Tweet service | Create and store short text posts | Sharded MySQL / Manhattan (Twitter's KV), Postgres, Cassandra |
| Unique ID generator | Time-sortable IDs | Twitter Snowflake |
| Timeline / Home feed service | Fan-out on write with caching, hybrid for celebrities | Redis timeline cache, Twitter's timeline service |
| Social graph | Follows, followers | FlockDB (Twitter), TAO (Facebook) |
| Real-time search | Index tweets within seconds | Twitter Earlybird (Lucene-based), Elasticsearch |
| **Trending topics service** | Streaming top-K and heavy hitters over a sliding window | Kafka + Flink / Storm / Heron, Count-Min Sketch, windowed counters |
| **Voting and ranking (Reddit)** | Upvote/downvote counters, "hot" ranking formula (score decays with time) | Redis counters, scheduled ranking recompute |
| Nested comments storage | Tree of replies | Adjacency list, materialized path, closure table; flatten and paginate deep threads |
| Community / subreddit service | Membership, rules, moderation roles | SQL + cache |
| Spam and abuse detection | Rules + ML on posts and accounts | ML pipelines, rate limiting |
| Media handling | Images/GIFs/video attachments | S3 + CDN |
| Notification service | Mentions, replies, follows | See Section 15 |
| Pagination | Cursor-based (not offset) for infinite scroll | `since_id` / `max_id` style cursors |

**Minimal flow:** Post → ID generator → DB → async fan-out into followers' Redis timelines → read path = fetch IDs from cache, hydrate from DB or cache, merge celebrity posts at read time.
**Trade-offs:** Fan-out strategy, counter accuracy vs cost (approximate counters are fine), hot posts and hot keys, eventual consistency in counts, ranking vs chronological.

---

## 12. Google Maps

**Special problem:** Render maps at any zoom, find the fastest route on a continent-sized graph, and compute ETAs from live traffic.

| Component | What it does | Real-life examples |
|---|---|---|
| **Map tile service** | Pre-renders the world into tiles per zoom level (z/x/y), stored and served via CDN | Google Maps, Mapbox, OpenStreetMap tile servers; raster or vector tiles (Mapbox Vector Tile format) |
| Tile storage | Billions of small files/objects | S3 / GCS plus CDN |
| Map data pipeline | Builds the base map from satellite, street-level, and crowdsourced data | OpenStreetMap, satellite imagery, ML for feature extraction |
| **Geospatial index** | Fast "what's near here" lookups | Geohash, Quadtree, **Google S2**, **Uber H3**, R-tree, PostGIS |
| Road network graph | Roads as nodes and edges with weights (distance, speed) | OSM-derived graph, partitioned into regions |
| **Routing engine** | Shortest/fastest path | Dijkstra, A*, **Contraction Hierarchies**; OSRM, GraphHopper, Valhalla |
| Hierarchical routing / graph partitioning | Avoids searching the entire world graph | Highway hierarchy, precomputed shortcuts |
| **Traffic service** | Ingests anonymous GPS probes into live speeds per road segment | Kafka + Flink/Spark Streaming |
| Map matching | Snaps noisy GPS points to the right road | HMM-based matching (Valhalla Meili, OSRM match) |
| **ETA service** | Predicts arrival time from live and historical traffic plus ML | Google Maps ETA (uses graph neural networks per DeepMind's published work) |
| Geocoding / reverse geocoding | Address to lat/long and back | Nominatim, Pelias, Google Geocoding API |
| Places / POI search | Search nearby restaurants, etc. | Elasticsearch geo queries, PostGIS |
| Navigation service | Turn-by-turn, rerouting on deviation | gRPC / WebSocket streaming plus location updates |
| Offline maps | Download regions for no-network use | Tile bundles, compressed vector tiles |

**Minimal flow:** Map view → client requests visible tiles from CDN. Route request → geocode → routing engine on the partitioned graph → apply live traffic weights → ETA service → return route polyline.
**Trade-offs:** Precompute vs on-demand routing, tile freshness vs cache hit, accuracy vs latency of ETA, bandwidth on mobile, privacy of location data.

---

## 13. Payment Systems (Razorpay / Stripe)

**Special problem:** Money must never be lost, duplicated, or silently wrong. Correctness beats speed.

| Component | What it does | Real-life examples |
|---|---|---|
| Merchant auth and API keys | Authenticates merchants, signs requests | Stripe API keys, Razorpay key ID / secret, HMAC signatures |
| **Idempotency layer** | Same request twice means one charge | Stripe `Idempotency-Key` header, dedupe table plus unique constraint |
| **Payment state machine** | `created → authorized → captured → settled`, plus `failed`, `refunded` | Orchestrated in a payments service with DB-backed states |
| Payment orchestration / smart routing | Chooses the best PSP / acquirer / bank route by success rate, cost | Juspay, Razorpay's routing, Stripe's routing |
| **Tokenization and card vault** | Never store raw card numbers outside a PCI-scoped vault | Stripe tokens, network tokens (Visa/Mastercard), HSMs (AWS CloudHSM, Thales) |
| PCI-DSS scope isolation | Keep card data in a small, hardened zone | Separate vault service and network segment |
| External integrations | Card networks, banks, wallets, **UPI** | Visa, Mastercard, RuPay, NPCI (UPI), net-banking gateways |
| 3-D Secure / OTP | Extra customer authentication | 3DS2, bank OTP pages |
| **Double-entry ledger** | Every movement is a debit and credit entry, append-only, auditable | Stripe/Square-style ledgers, TigerBeetle, Modern Treasury |
| Strongly consistent DB | ACID transactions | PostgreSQL, MySQL, Spanner |
| Distributed transaction pattern | Keep services consistent without 2PC | **Saga**, **Transactional Outbox**, event sourcing |
| Webhook service | Notifies merchants of payment events with signed payloads, retries with backoff | Stripe webhooks, Razorpay webhooks |
| **Reconciliation service** | Daily batch matching of your ledger against bank/network files to catch mismatches | Spark/batch jobs, settlement report parsers |
| Settlement and payout service | Moves money to merchants on schedule (T+N) | Razorpay settlements, Stripe payouts |
| Fraud / risk engine | Rules and ML scoring before authorizing | Stripe Radar, rules engines, velocity checks |
| Refunds, disputes, chargebacks | Reverse flows | Dedicated state machines |
| Audit logs and compliance | Immutable trails | Append-only logs, WORM storage |

**Minimal flow:** Merchant calls create-payment with an idempotency key → payment record `created` → customer pays (tokenized card/UPI) → route to PSP/bank → result updates the state machine and ledger in one DB transaction → outbox event → webhook to merchant → nightly reconciliation → settlement.
**Trade-offs:** Consistency over availability for the ledger, handling timeouts from banks (unknown status means you must *query status* and never assume failure), retries need idempotency, async confirmation via webhooks, regulatory requirements (PCI-DSS, RBI rules in India).

---

## 14. Ride-Sharing App (Uber / Ola)

**Special problem:** Track millions of moving drivers in real time and match riders to the best nearby driver in seconds.

| Component | What it does | Real-life examples |
|---|---|---|
| Driver location ingestion | Drivers send GPS every ~3–5 seconds | Kafka, MQTT / gRPC streaming, WebSocket |
| **Live location store + geospatial index** | In-memory "who is near this point" | Redis GEO, in-memory H3 / S2 / geohash grid, Uber H3 |
| **Matching / Dispatch service** | Picks the best driver (distance, ETA, rating, acceptance) | Uber DISCO |
| Supply-demand service | Tracks demand vs available drivers per area | Streaming aggregation (Flink) per H3 cell |
| **Surge / dynamic pricing** | Adjusts prices by demand-supply ratio | Uber surge pricing |
| Routing and ETA service | Pickup ETA and trip route | Maps service (Section 12), OSRM, Google Maps API |
| **Trip service (state machine)** | `requested → driver assigned → arrived → started → completed / cancelled` | SQL / Uber Schemaless (MySQL-based) |
| Real-time communication | Push trip updates to rider and driver apps | WebSockets, gRPC streams, FCM / APNs |
| Request distribution among servers | Locates which server owns a given city or area | Uber Ringpop (consistent-hashing based), Consistent hashing |
| Payments and wallet | Fare calculation and charge | See Section 13 |
| Ratings and reviews | Post-trip feedback | SQL + aggregates |
| Driver onboarding and KYC | Document verification | Third-party KYC, internal workflow |
| Fraud and safety | Fake GPS, SOS, trip anomaly detection | ML rules |
| Notification | Trip and promo messages | See Section 15 |

**Minimal flow:** Rider requests → trip service creates a trip → dispatch queries geospatial index for nearby drivers → ranks by ETA → offers to a driver (timeout, then next) → driver accepts → live tracking until completion → payment.
**Trade-offs:** Location freshness vs write load (drivers produce huge write volume, so keep it in memory and don't persist every ping to SQL), matching latency vs optimality (batch matching vs greedy), geo-sharding by city, consistency of driver assignment (a driver must not be double-booked, so use atomic reservation/locking).

---

## 15. Notification System

**Special problem:** Deliver millions of messages across channels reliably, respecting preferences, without spamming or being blocked by providers.

| Component | What it does | Real-life examples |
|---|---|---|
| Notification API / event consumer | Other services trigger notifications via API or events | REST/gRPC, Kafka events |
| Template service | Renders content with variables and localisation | Thymeleaf, FreeMarker, Handlebars (Java stack), SendGrid templates |
| User preference and opt-out service | Channel choice, quiet hours, unsubscribe | SQL + cache |
| Device token registry | Maps user to device tokens (FCM/APNs) | DB with cleanup of invalid tokens |
| Router / priority manager | Chooses channel(s) and priority (OTP is urgent, marketing is low) | Separate queues per channel and priority |
| Per-channel queues | Isolation so a slow channel does not block others | Kafka topics / SQS queues per channel |
| **Channel workers / providers** | Actually send | |
| ↳ Mobile push | | Firebase Cloud Messaging (Android/web), Apple APNs (iOS), OneSignal |
| ↳ SMS | | Twilio, AWS SNS, MSG91, Gupshup, Kaleyra |
| ↳ Email | | Amazon SES, SendGrid, Mailgun, Postmark |
| ↳ In-app / real-time | | WebSocket, SSE |
| ↳ WhatsApp | | WhatsApp Business API |
| Rate limiting and throttling | Protect users from spam and respect provider limits | Redis token bucket |
| Dedup and idempotency | Avoid sending the same alert twice | Dedupe keys with TTL in Redis |
| Retry with backoff and DLQ | Handle provider failures | SQS DLQ, Kafka retry topics |
| Scheduling and batching / digests | "Send at 9 AM", daily summaries | Scheduler (Section 8) |
| Delivery tracking and analytics | Delivered / opened / bounced via provider callbacks | Provider webhooks, ClickHouse, Kafka |
| Compliance | Regulatory rules for SMS and email | TRAI DLT registration (India SMS), CAN-SPAM, GDPR consent |

**Minimal flow:** Event → notification service → check preferences, dedupe, rate limit → render template → publish to per-channel queue → worker calls provider → track status → retry or DLQ.
**Trade-offs:** At-least-once means occasional duplicates, so dedupe, provider failover (a secondary SMS vendor), priority isolation (OTP never stuck behind marketing), latency for OTPs vs batching for marketing.

---

## 16. Distributed URL Shortener

**Special problem:** Generate short unique codes at scale and redirect extremely fast (read-heavy, about 100:1).

| Component | What it does | Real-life examples |
|---|---|---|
| **Key generation** | Produces a unique 6–8 char Base62 code | Options below |
| ↳ Counter + Base62 | Encode an incrementing ID | Redis `INCR`, ZooKeeper-allocated ID ranges per server |
| ↳ Pre-generated key service (KGS) | Offline pool of unused keys handed out in batches | Dedicated KGS DB with used/unused tables |
| ↳ Hash + truncate | MD5/SHA of URL, take N chars, handle collisions | Needs collision check |
| ↳ Snowflake ID to Base62 | Distributed and time-sortable | Twitter Snowflake style |
| Datastore (key-value access) | `short_code → long_url`, expiry, owner | DynamoDB, Cassandra, MySQL with sharding |
| **Cache for redirects** | Hot links served from memory | Redis / Memcached (LRU, 20% of URLs serve 80% of traffic) |
| Redirect service | Looks up and returns HTTP 301/302 | 301 = cacheable (less load, less analytics), 302 = every click hits you (better analytics) |
| Bloom filter (optional) | Cheap "does this key exist" check | In-memory Bloom filter |
| Analytics pipeline | Clicks, geo, device, referrer, counted asynchronously | Kafka → Flink/Spark → ClickHouse / Druid |
| Expiry and cleanup | TTL plus lazy delete on access plus periodic sweep | DB TTL (DynamoDB), cron job |
| Custom alias and validation | User-chosen short names, URL sanity checks | Uniqueness check |
| Abuse / malware protection | Block phishing and malicious URLs | Google Safe Browsing API |
| Rate limiter | Prevent mass creation abuse | Section 4 |

**Minimal flow:** Create: get unique ID → Base62 → store mapping → return short URL. Redirect: LB → cache lookup → on miss DB → 301/302 → fire async click event.
**Trade-offs:** Predictable codes are guessable (use random or shuffled), collision handling for hashing, 301 vs 302, KGS is a single point of failure so keep it replicated, DB sharding by short-code hash.
**Real examples:** Bitly, TinyURL, t.co (Twitter), Google's discontinued goo.gl.

---

## 17. Distributed Web Crawler

**Special problem:** Crawl billions of pages politely, avoid duplicates and traps, and keep content fresh.

| Component | What it does | Real-life examples |
|---|---|---|
| Seed URL list | Starting points | Curated lists, sitemaps |
| **URL Frontier** | Prioritised queue of URLs to crawl, with *politeness*: per-host queues, one connection and crawl delay per domain | Mercator architecture, StormCrawler frontier, Apache Nutch generator |
| Priority / freshness scheduler | Decides what to re-crawl and when (change frequency, PageRank, importance) | Googlebot scheduling |
| DNS resolver with cache | DNS lookups are a bottleneck at scale | Custom async DNS cache |
| **Fetcher workers** | Download pages in parallel | Heritrix, Apache Nutch, Crawler4j and Jsoup (Java), Scrapy |
| Headless browser fleet (for JS pages) | Renders JavaScript-heavy sites | Puppeteer, Playwright, headless Chrome |
| robots.txt handler and cache | Respects crawl rules | Per-domain robots cache |
| **Content parser / link extractor** | Extracts text and outgoing links | Jsoup, Apache Tika |
| **URL normalizer / canonicalizer** | Same page, different URL forms | Lowercase host, strip fragments, sort params |
| **URL dedup ("seen URLs")** | Avoid recrawling the same URL | Bloom filter, DB / Redis set |
| **Content dedup** | Detect duplicate and near-duplicate pages | Checksums, **SimHash / MinHash** |
| Spider-trap detection | Infinite calendars, session IDs | Depth limits, URL pattern limits |
| Raw content storage | Stores fetched HTML | HDFS, S3 |
| Metadata store | URL status, last crawl time, content hash | Bigtable / HBase / Cassandra |
| Partitioning across crawlers | Each crawler owns a set of hosts | Consistent hashing on hostname |
| Inter-stage queues | Decouples fetch, parse, store | Kafka |
| Downstream indexer | Feeds the search engine | Section 6 |

**Minimal flow:** Frontier → pick URL (respecting politeness) → fetcher downloads → store raw → parser extracts text and links → normalize and dedup links → add new URLs to the frontier → send content to the indexer.
**Trade-offs:** Breadth-first vs priority crawling, politeness vs throughput, freshness vs crawl budget, JS rendering is 10x more expensive, content dedup accuracy vs cost.
**Real examples:** Googlebot, Bingbot, Common Crawl, Internet Archive's Heritrix.

---

## 18. Distributed Messaging System (Chat: WhatsApp / Slack / Messenger)

> **Assumption:** Your list has both "Distributed Messaging Queue" (Section 2) and "Distributed Messaging System". I'm treating this one as a **chat/messaging app**. If you meant something Kafka-like, Sections 2 and 3 already cover it.

**Special problem:** Deliver messages in real time, in order, to online and offline users, with delivery receipts, across devices.

| Component | What it does | Real-life examples |
|---|---|---|
| **Chat / WebSocket gateway servers** | Hold millions of persistent connections | Netty (Java), Spring WebSocket + STOMP, Erlang/ejabberd (WhatsApp's stack), Socket.IO |
| **Connection / session registry** | Which user is connected to which gateway server | Redis hash with TTL, ZooKeeper |
| Message routing service | Finds the recipient's gateway and forwards | Internal pub-sub (Redis Pub/Sub, Kafka) between gateways |
| Message ID and ordering | Per-conversation sequence numbers or time-sortable IDs | Snowflake IDs, per-chat monotonic sequence |
| **Message store** | Write-heavy, partitioned by conversation | Cassandra, HBase (Facebook Messenger, historically), ScyllaDB (Discord migrated from Cassandra) |
| Delivery receipts | Sent, delivered, read acks | Ack protocol over the same connection |
| **Offline queue and push notifications** | Store undelivered messages and ping the device | FCM, APNs, per-user inbox in DB |
| **Presence service** | Online/last seen, via heartbeats | Redis keys with TTL, Redis pub-sub for updates |
| Group chat fan-out | Deliver to N members (limit group size) | Fan-out worker over Kafka |
| Media service | Upload image/video/files, thumbnails, link previews | S3 + CDN, presigned URLs |
| **End-to-end encryption (E2EE)** | Only endpoints can read | Signal Protocol (WhatsApp, Signal), key distribution server |
| Multi-device sync | Same account on phone + laptop | Per-device queues and cursors |
| Typing indicators | Ephemeral signals, no persistence | Pub-sub only |
| Message search | Search history | Elasticsearch (not possible server-side with strong E2EE) |
| Retention and deletion | TTL, "delete for everyone" | DB TTL, tombstones |

**Minimal flow:** Sender → WebSocket gateway → message service assigns ID and persists → lookup recipient in session registry → if online, forward via their gateway, else store in the offline queue and send a push → recipient acks → delivery/read receipts flow back.
**Trade-offs:** Gateway statefulness (reconnect storms, sticky connections), ordering in groups, at-least-once plus client dedupe by message ID, E2EE breaks server-side features, 1:1 vs large group fan-out, long polling fallback.

---

## 19. Auto-Completion (Typeahead) System

**Special problem:** Return the top suggestions for a prefix in about 50–100 ms on every keystroke, over a huge query corpus.

| Component | What it does | Real-life examples |
|---|---|---|
| **Trie (prefix tree) with top-K per node** | Walk the prefix and read pre-computed best suggestions | Custom trie, Lucene FST (Finite State Transducer) |
| Data collection (query logs) | Records what users search | Search service logs → Kafka |
| **Aggregation / ranking pipeline** | Counts query frequency with recency decay, trending boost | Spark/MapReduce (batch), Flink (streaming) |
| **Trie builder (offline)** | Periodically builds a new trie snapshot and swaps it in | Daily / hourly build jobs |
| Trie / suggestion serving store | Serves prefix lookups | In-memory on app nodes (sharded by prefix range), Redis (ZSET per prefix), Elasticsearch Completion Suggester |
| Sharding by prefix | Balances load (letters are skewed, so shard by data volume) | Range-based shard map |
| Multi-layer cache | Browser cache, CDN, Redis for top prefixes | Browser `Cache-Control`, CDN, Redis |
| Ranking signals | Popularity, recency, location, language, personalization | Weighted scoring |
| Filter / blocklist service | Remove offensive or unsafe suggestions | Blocklist applied at build and serve time |
| Fuzzy / typo tolerance | Handle misspellings | Edit distance, n-gram index (Elasticsearch fuzzy) |
| Client optimisation | Debounce (~100–200 ms), cancel stale requests, prefetch | JS debounce, request cancellation |

**Minimal flow:** User types → debounced request → cache → on miss, the trie shard returns the top-K for the prefix → client shows the results. Offline: logs → aggregate → build new trie → deploy.
**Trade-offs:** Freshness (trending queries) vs build cost (hybrid batch + real-time layer), memory for the trie (limit depth and store only top-K), personalization vs cache efficiency, limiting suggestions to the top 5–10.
**Real examples:** Google Suggest, Amazon search suggestions, Algolia, Elasticsearch suggesters.

---

## 20. Collaboration System (Google Docs)

**Special problem:** Many users edit the same document simultaneously and everyone converges to the same result without conflicts.

| Component | What it does | Real-life examples |
|---|---|---|
| **WebSocket collaboration gateway** | Real-time two-way channel per editing session | Netty, Socket.IO, Spring WebSocket |
| **Concurrency control algorithm** | Merges concurrent edits | **Operational Transformation (OT)**: Google Docs, Etherpad, ShareDB. **CRDTs**: Yjs, Automerge, Figma (CRDT-inspired) |
| Per-document collaboration server | One server (or leader) orders operations for a given doc, so route all clients of a doc to the same node | Consistent hashing or sticky routing by `docId` |
| **Operation log** | Append-only log of every edit, the source of truth for history | Kafka, Cassandra, Bigtable |
| Snapshots / checkpoints and compaction | Avoid replaying millions of ops, so store periodic full snapshots | Snapshot every N ops into the doc store |
| Document store | Stores snapshots and metadata | Spanner / Bigtable (Google), PostgreSQL, S3 |
| Presence and cursor awareness | Show other users' cursors and selections | Redis Pub/Sub, Yjs awareness protocol |
| Version history / revisions | Time travel, restore | Replay ops, named snapshots |
| Permissions and sharing (ACL) | Owner/editor/commenter/viewer, link sharing | ACL service plus cache |
| Comments and suggestions | Anchored to text ranges, so anchors must move as the text changes | Separate comment store with range transformation |
| Offline editing and sync | Local queue then merge on reconnect | IndexedDB + CRDT (works naturally), OT needs a rebase |
| Export / import | PDF, DOCX | Headless LibreOffice, Apache POI (Java) |
| Search / Drive integration | Find docs | Elasticsearch |

**Minimal flow:** Client opens the doc, loads the latest snapshot, then replays recent ops, then connects to the doc's collaboration server. Local edit is applied instantly, sent as an op, the server transforms and orders it, persists it, and broadcasts it to the other clients.
**Trade-offs:** OT (needs a central server, proven, complex transforms) vs CRDT (decentralised and offline-friendly, higher metadata overhead), single-writer-per-doc bottleneck for very popular docs, latency vs consistency, memory/compaction for long histories.

---

## 21. ChatGPT-like System (LLM Serving)

> Exact internals of OpenAI's systems are not public. These are the standard components of an LLM serving stack that you can defend in an interview.

**Special problem:** GPU inference is expensive and slow. You must stream tokens, batch requests efficiently, and manage long context and safety.

| Component | What it does | Real-life examples |
|---|---|---|
| Chat frontend and **streaming** | Shows tokens as they are generated | SSE or WebSockets |
| Gateway: auth, quota, rate limit, billing | Limits per user/org, often in *tokens per minute* | API gateway + Redis counters, metering pipeline |
| Conversation service and store | Chat history, titles, sharing | PostgreSQL / DynamoDB / Cassandra |
| **Prompt / context builder** | Assembles system prompt + history + tools, truncates or summarizes to fit the context window | App logic, tokenizers (tiktoken, SentencePiece) |
| Safety and moderation | Check input and output | Moderation models/APIs, policy classifiers |
| **Inference router / orchestrator** | Chooses model and region, handles fallback | Internal router, load balancing on queue depth |
| Request queue and scheduler | Priority tiers (free vs paid), backpressure | Kafka/Redis queue, custom scheduler |
| **Inference servers with continuous batching** | Merge in-flight requests token by token to keep GPUs busy | vLLM, NVIDIA Triton, TensorRT-LLM, Hugging Face TGI |
| **GPU cluster and orchestration** | Runs the models | NVIDIA A100/H100 GPUs, Kubernetes with GPU scheduling, Ray Serve |
| **KV cache management** | Stores attention keys/values to avoid recomputing, memory is the bottleneck | PagedAttention (vLLM), prefix/prompt caching |
| Model parallelism | Models too large for one GPU | Tensor parallel, pipeline parallel (Megatron, DeepSpeed) |
| Inference optimisations | Lower cost and latency | Quantization (INT8/FP8), speculative decoding, FlashAttention |
| Model registry and weight storage | Versioned weights, rollout, A/B tests | S3 / GCS, MLflow |
| **RAG: embeddings + vector DB** | Retrieve relevant documents to ground answers | Pinecone, Weaviate, Milvus, pgvector, FAISS |
| Tools / function calling | Calls external APIs, search, code execution | Function-calling layer, **sandboxed code interpreter** (gVisor, Firecracker microVMs) |
| Feedback and training data pipeline | Thumbs up/down, human labeling for fine-tuning and RLHF | Kafka → data lake (S3) → labeling tools |
| Observability specific to LLMs | TTFT (time to first token), tokens/sec, GPU utilization, cost per request | Prometheus + Grafana, Langfuse, OpenTelemetry |
| GPU autoscaling and capacity planning | GPUs are scarce and slow to scale | Queue-depth-based scaling, reserved capacity |

**Minimal flow:** User message → gateway (auth, token quota) → build prompt from history (+ RAG results) → safety check → queue → inference server (continuous batching, KV cache) → stream tokens back via SSE → post-filter → persist the conversation.
**Trade-offs:** Latency vs throughput (batch size), cost per token, context length vs memory, streaming complicates retries, safety checks add latency, GPU capacity is the main bottleneck.

---

## 22. Customer Support Bot

**Special problem:** Resolve most queries automatically using company knowledge, take safe actions, and hand off to humans cleanly when needed.

| Component | What it does | Real-life examples |
|---|---|---|
| **Channel integrations** | Web widget, mobile, WhatsApp, email, Slack | Twilio, WhatsApp Business API, Intercom, Zendesk Messaging |
| Chat gateway | Real-time session handling | WebSocket / SSE |
| Session and conversation state | Context for multi-turn dialogue | Redis (short-term), DB (history) |
| **Intent / NLU layer** (classic bots) | Identify intent and extract entities | Dialogflow, Rasa, AWS Lex |
| **LLM service** (modern bots) | Generates answers | Hosted LLM APIs (Claude, GPT, Gemini) or self-hosted models |
| **Dialogue manager / orchestrator** | Decides: answer from KB, call a tool, ask a clarifying question, or escalate | Custom state machine / agent framework (LangChain, LangGraph, Spring AI for Java) |
| **Knowledge base ingestion pipeline** | Docs / FAQs / tickets to chunk, embed, index | Apache Tika, chunkers, embedding models |
| **Vector DB + retrieval (RAG)** | Finds the relevant passages | Pinecone, Weaviate, Milvus, pgvector, OpenSearch k-NN |
| Guardrails | PII redaction, prompt-injection defence, restricting to approved sources, grounding with citations | Guardrails libraries, moderation APIs, regex/PII detectors |
| **Tool / action layer** | Safe backend calls such as order status, refund, reset password, with scoped auth and confirmation for risky actions | Function calling to internal REST APIs, OAuth scopes |
| **Human handoff / escalation** | Route to a live agent with full context, based on low confidence, sentiment, or explicit request | Zendesk, Freshdesk, Salesforce Service Cloud, Genesys |
| Ticketing integration | Create/update tickets automatically | Jira Service Management, Zendesk, ServiceNow |
| Sentiment analysis and triggers | Detect frustration, VIP customers | Sentiment models |
| Analytics and feedback loop | CSAT, containment/deflection rate, unanswered-question gaps | Kafka → warehouse, Looker/Grafana |
| Conversation logging, audit and evaluation | Compliance plus offline eval of answer quality | Data lake, LLM-eval tools |
| Multilingual support | Language detection and translation | Multilingual models, translation APIs |

**Minimal flow:** User message → channel → gateway → orchestrator loads session → retrieve KB passages (RAG) → LLM drafts an answer with guardrails → optionally calls tools → reply. If confidence is low or the user asks, escalate to a human with the transcript attached.
**Trade-offs:** Hallucination vs coverage (ground answers in sources and refuse when unsure), cost and latency of LLM calls (cache common questions), tool permissions and prompt-injection risk (least privilege plus confirmation on money-moving actions), human handoff UX.

---

# PART 3: QUICK MATRIX (which common components each system needs)

✔ = needed, ◐ = optional / depends, – = not needed

| # | System | LB / Proxy | API GW + Auth | Cache | DB | Blob | Queue / Stream | CDN | Search index | WebSocket / Streaming |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Distributed Cache | ◐ | ◐ | ✔ (is the system) | – | – | – | – | – | – |
| 2 | Messaging Queue | ✔ | ◐ | – | ◐ | – | ✔ (is the system) | – | – | – |
| 3 | Pub-Sub | ✔ | ◐ | – | ◐ | – | ✔ (is the system) | – | – | ◐ |
| 4 | Rate Limiter | ✔ | ✔ | ✔ | ◐ | – | – | – | – | – |
| 5 | Blob Store | ✔ | ✔ | ◐ | ✔ | ✔ (is the system) | ◐ | ◐ | – | – |
| 6 | Search | ✔ | ✔ | ◐ | ✔ | ◐ | ✔ | – | ✔ (is the system) | – |
| 7 | Logging | ✔ | ◐ | – | ✔ | ✔ | ✔ | – | ✔ | – |
| 8 | Task Scheduler | ✔ | ✔ | ◐ | ✔ | – | ✔ | – | – | – |
| 9 | YouTube / Netflix | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ | – |
| 10 | Instagram / TikTok | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ | – |
| 11 | Twitter / Reddit | ✔ | ✔ | ✔ | ✔ | ◐ | ✔ | ◐ | ✔ | ◐ |
| 12 | Google Maps | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ | ◐ |
| 13 | Payments | ✔ | ✔ | ◐ | ✔ (ACID) | – | ✔ | – | ◐ | – |
| 14 | Ride Sharing | ✔ | ✔ | ✔ | ✔ | – | ✔ | – | ◐ | ✔ |
| 15 | Notification | ✔ | ✔ | ◐ | ✔ | – | ✔ | – | – | ◐ |
| 16 | URL Shortener | ✔ | ✔ | ✔ | ✔ | – | ◐ | ◐ | – | – |
| 17 | Web Crawler | – | – | ◐ | ✔ | ✔ | ✔ | – | ◐ | – |
| 18 | Chat Messaging | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ | ◐ | ✔ |
| 19 | Autocomplete | ✔ | ✔ | ✔ | ◐ | – | ◐ | ◐ | ✔ | – |
| 20 | Google Docs | ✔ | ✔ | ◐ | ✔ | ◐ | ◐ | – | ◐ | ✔ |
| 21 | ChatGPT | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ | ◐ | ◐ (vector) | ◐ (SSE) |
| 22 | Support Bot | ✔ | ✔ | ✔ | ✔ | ◐ | ◐ | – | ✔ (vector) | ✔ |

---

# PART 4: Patterns That Repeat Across Systems (pattern recognition)

| Pattern | Where it shows up |
|---|---|
| **Consistent hashing** | Distributed cache, blob store placement, crawler host partitioning, Docs per-document routing, ride-sharing city ownership |
| **Fan-out (write vs read)** | Pub-Sub, Twitter/Instagram feeds, chat group messages, notifications |
| **Idempotency + at-least-once** | Queues, payments, schedulers, notifications, webhooks |
| **Geospatial indexing (Geohash / S2 / H3 / Quadtree)** | Maps, ride sharing, "nearby" search |
| **Inverted index** | Search, autocomplete, log search, tweet search |
| **Pre-compute offline, serve online** | Autocomplete trie, recommendations, map tiles, video renditions |
| **Presigned URL direct upload** | Blob store, video, images, chat media |
| **Async pipeline (queue to workers)** | Video transcoding, image processing, notifications, indexing, analytics |
| **Cache-aside + CDN** | URL shortener, feeds, video, static assets |
| **State machine in DB** | Payments, trips, jobs, video processing status |
| **Heartbeat + lease + re-assignment** | Task scheduler, blob store repair, chat presence, worker fleets |
| **Approximate algorithms** | Bloom filter (crawler, URL shortener), Count-Min Sketch (trending), HyperLogLog (unique counts), SimHash (near-duplicates) |
| **WebSocket plus session registry** | Chat, collaboration, ride tracking, live notifications |
| **CDC (Change Data Capture)** | Keep search index, cache, and analytics in sync with the DB (Debezium) |
| **Saga / Outbox** | Payments, orders, any multi-service workflow |

---

## Suggested Study Order

1. **Foundations (do first):** Cache → Queue → Pub-Sub → Rate Limiter → URL Shortener. These teach most of Part 1.
2. **Storage and data systems:** Blob Store → Search → Logging → Autocomplete → Task Scheduler → Web Crawler.
3. **Real-time systems:** Chat → Notification → Ride Sharing → Collaboration (Docs).
4. **Large product designs:** Twitter/Reddit → Instagram/TikTok → YouTube/Netflix → Google Maps → Payments.
5. **Modern AI systems:** ChatGPT → Support Bot.

For each system, practise: **requirements → estimates → API → data model → baseline diagram (Part 1.6) → add the Part 2 components → deep dive → trade-offs.**
