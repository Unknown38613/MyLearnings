Here's the exact scoped breakdown — what to actually learn for each, not the whole textbook chapter.

## 1. Load Balancing

- **Algorithms**: round-robin, weighted round-robin, least-connections, consistent hashing (know *why* consistent hashing minimizes reshuffling when nodes are added/removed — this is the actual interview point, not the algorithm's internals)
- **L4 vs L7 load balancing** — one-line distinction (transport layer vs application layer routing)
- **Health checks** — how LB detects a dead node (just conceptually, not implementation)
- Skip: virtual nodes math, hash ring implementation details, HAProxy/nginx config

## 2. Caching

- **Cache-aside (lazy loading)** — app checks cache, on miss reads DB and populates cache. Know this cold, it's the default answer.
- **Write-through** — write goes to cache and DB synchronously (strong consistency, slower writes)
- **Write-behind (write-back)** — write goes to cache, DB updated asynchronously (fast writes, risk of data loss)
- **Write-around** — write goes directly to DB, cache populated only on read (good for write-heavy, rarely-read-again data)
- **Eviction policies**: LRU, LFU (just know LRU well — it's also a common DSA question, dual purpose)
- **Cache invalidation** — TTL-based vs explicit invalidation on write
- Skip: distributed cache internals (how Redis cluster shards internally), CDN edge caching specifics

## 3. Sharding

- **Hash-based sharding** — `hash(key) % N`, pros (even distribution) and the big con (resharding pain when N changes)
- **Range-based sharding** — pros (range queries are easy), con (hotspotting if data isn't uniform, e.g. all recent timestamps hit one shard)
- **Directory-based sharding** — a lookup service maps key→shard (mention only as third option)
- **Resharding problem** — why hash-based sharding is painful to scale, and that consistent hashing is the fix (ties back to load balancing topic — connect the dots)
- Skip: actual shard rebalancing algorithms, vitess/citus-style implementations

## 4. Sync vs Async + Pub-Sub

- **When to go async**: operation isn't needed for the immediate response (notifications, emails, analytics events, thumbnail generation)
- **Message queue vs Pub-Sub distinction**: queue = one consumer processes each message (point-to-point, e.g. task processing); pub-sub = multiple consumers each get a copy (e.g. order event fans out to 3 services)
- **At-least-once vs at-most-once delivery** — just the vocabulary, know queues can duplicate delivery and consumers should handle it (ties to idempotency)
- Name-drop familiarity: Kafka (log-based, pub-sub + replay), RabbitMQ (traditional queue) — know the one-line difference, not internals
- Skip: Kafka partition/consumer-group internals, exactly-once semantics debates

## 5. Rate Limiting

- **Token bucket** — learn this one deeply, it's the default expected answer: bucket holds tokens, refills at fixed rate, request consumes a token, reject if empty (allows bursts up to bucket size)
- **Leaky bucket** — contrast: smooths to a fixed output rate, no bursts (mention as alternative, know the one-sentence difference from token bucket)
- **Fixed window vs sliding window counter** — fixed window has the boundary-burst problem (2x requests possible at window edge); sliding window fixes it
- Be ready to **design it end-to-end**: where does the counter live (Redis), how do you handle it per-user vs per-IP vs per-API-key, what happens on limit breach (429 response)
- Skip: distributed rate limiter consistency issues across multiple LB nodes (SDE-2+ depth)

## 6. CAP / Consistency

- **CAP theorem** — one clean explanation: under a network partition, you choose consistency or availability, can't have both
- **Strong consistency** — every read sees the latest write (needed for: bank balance, inventory count)
- **Eventual consistency** — reads may be stale temporarily but converge (fine for: like counts, follower counts, feed rankings)
- Be able to **classify a given feature** as needing strong vs eventual — that's the actual interview test, not reciting CAP theorem
- Skip: PACELC, quorum math (W+R>N), vector clocks

## "Good to mention" tier — keep genuinely shallow

- **Circuit breaker**: three states (closed/open/half-open), one sentence each — don't go deeper
- **API Gateway**: single entry point, handles auth/routing/rate-limiting centrally — one sentence
- **Idempotency**: idempotency key on write APIs so retries don't double-process — one sentence + one example (payment retry)

---

**Total realistic learning surface**: ~6 core topics, each learnable to interview-depth in a focused 1–2 hour session (concept + 1 worked example + tradeoff articulation). That's a weekend, not a jungle — the sprawl you're seeing is mostly SDE-2+ depth bleeding into SDE-1 prep material online. Want me to turn this into a study tracker artifact you can check off, or start drilling you on one topic with follow-up "why not X" questions the way an interviewer would?
