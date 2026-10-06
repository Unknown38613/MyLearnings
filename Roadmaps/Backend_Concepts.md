# Backend Concepts: SDE-1 Interview Roadmap

Rule of thumb: SDE-1 backend rounds test **fundamentals you can explain clearly** and a **basic sense of trade-offs**, not deep distributed-systems theory.
Priority: **P0 = asked almost every time**, **P1 = asked often**, **P2 = skim only if time remains**.


## P0: Must Know

### 1. HTTP and Web Basics
- Request/response structure: method, URL, headers, body, status code
- HTTP methods, **safe vs idempotent** (GET/PUT/DELETE idempotent, POST not)
- Status codes: 200, 201, 204, 301/302, 400, 401, 403, 404, 409, 429, 500, 502, 503
- **401 vs 403**, **PUT vs PATCH**
- HTTP vs HTTPS (TLS: what it gives you, at a high level)
- Cookies vs sessions vs tokens
- What happens when you type a URL in the browser (DNS -> TCP -> TLS -> HTTP -> response)
- Stateless vs stateful servers

### 2. REST API Design
- Resource-based URIs (`/users/{id}/orders`), nouns not verbs
- Proper status codes and error response format
- **Pagination** (offset vs cursor, trade-offs)
- Filtering, sorting
- Versioning (URI vs header) at concept level
- Idempotency: why it matters for retries (payments, POST with idempotency key)
- DTOs vs entities, input validation

### 3. Databases: SQL
- Joins (INNER, LEFT, RIGHT, FULL), GROUP BY, HAVING, subqueries
- WHERE vs HAVING, DELETE vs TRUNCATE vs DROP
- Primary key, foreign key, unique, constraints
- **Normalization** (1NF, 2NF, 3NF) and when to denormalize
- **Indexes:** what they are (B-Tree), why they speed reads, cost on writes, composite index and leftmost-prefix rule, when an index is *not* used
- **Transactions and ACID**
- **Isolation levels** and the anomalies they prevent (dirty read, non-repeatable read, phantom read)
- Deadlocks: what they are, how to avoid (consistent lock ordering)
- Query optimization: `EXPLAIN`, avoiding `SELECT *`, N+1 queries

### 4. Authentication and Authorization
- AuthN vs AuthZ
- Session-based vs token-based auth
- **JWT:** structure (header.payload.signature), why signed not encrypted, expiry, refresh tokens, where not to store (sensitive data in payload)
- Password storage: **hash + salt** (BCrypt), never plain or reversible encryption
- RBAC basics
- OAuth2 at one-paragraph level (delegated access; "Login with Google")

### 5. Caching
- Why cache (latency, DB load)
- Where: client, CDN, application (in-memory), distributed (Redis)
- **Cache-aside pattern** (most common answer)
- Write-through vs write-back (concept)
- **Invalidation and TTL**, stale data problem
- Eviction: LRU, LFU (you should be able to code LRU)
- Cache stampede / thundering herd (just know the name and one fix)

### 6. Concurrency (Java)
- Process vs thread, thread lifecycle
- `synchronized`, `volatile` (visibility vs atomicity), `Atomic*` classes
- **Race condition**, deadlock (4 conditions)
- `ExecutorService` / thread pools (why not `new Thread()` per task)
- `ConcurrentHashMap` vs `HashMap` vs `Hashtable`
- `Future` vs `CompletableFuture` basics
- Producer-consumer problem (`BlockingQueue`)

### 7. Core System Design Concepts (vocabulary level)
- **Horizontal vs vertical scaling**
- **Load balancer** (round robin, least connections), why stateless services scale easier
- **Database replication** (primary/replica, read scaling) and **sharding** (partitioning data, shard key)
- **CAP theorem** (consistency vs availability under partition) and eventual consistency
- Latency vs throughput
- **Rate limiting** (token bucket / sliding window idea)


## P1: Asked Often

### 8. NoSQL and Choosing Storage
- SQL vs NoSQL: when each fits
- Types: key-value (Redis), document (MongoDB), wide-column (Cassandra), graph
- Redis basics: data structures, TTL, use cases (cache, session store, rate limiter, leaderboard)

### 9. Messaging and Async Processing
- Why queues (decoupling, buffering spikes, async work)
- Queue vs pub/sub
- Kafka vs RabbitMQ at concept level (log with partitions vs broker with queues)
- **Delivery semantics:** at-most-once, at-least-once, exactly-once (and why consumers should be idempotent)
- Dead letter queue, retries

### 10. Microservices vs Monolith
- Pros/cons of each (don't claim microservices are always better)
- API Gateway, service-to-service communication (REST vs gRPC vs messaging)
- Basic failure handling: timeouts, retries with backoff, **circuit breaker** idea
- Distributed transaction problem; saga pattern name and idea

### 11. Security Basics
- OWASP basics: **SQL injection** (use prepared statements), XSS, CSRF, broken auth
- CORS: what it is, why browsers enforce it
- Input validation, never trust the client
- Secrets: never commit to git, use env vars / secret managers
- HTTPS everywhere

### 12. Design Patterns and OOP (usually paired with backend rounds)
- SOLID (be able to give a one-line example for each)
- Singleton, Factory, Builder, Strategy, Observer, Decorator
- Dependency injection as a design principle

### 13. Observability and Debugging
- Logging levels, structured logs, correlation/request IDs
- Metrics vs logs vs traces (what each answers)
- How you'd debug a slow API (check logs/metrics -> DB queries -> N+1 -> missing index -> external call latency)

### 14. DevOps Minimum
- Git: merge vs rebase, resolving conflicts
- Docker: image vs container, Dockerfile basics
- CI/CD: what a pipeline does (build -> test -> deploy)
- Environments: dev / staging / prod, config per environment


## P2: Skim Only

- Consensus (Raft/Paxos), distributed locks in depth
- Consistent hashing details, bloom filters, CRDTs
- Kubernetes internals
- gRPC/Protobuf details, GraphQL
- Event sourcing / CQRS
- Search engines (Elasticsearch), time-series DBs


## Classic Problems to Practice (SDE-1 System/LLD Warm-ups)

| Problem | Concepts it tests |
|---------|-------------------|
| URL shortener | hashing/ID generation, DB choice, caching, read-heavy scaling |
| Rate limiter | token bucket, Redis, concurrency |
| LRU cache | HashMap + doubly linked list, thread safety |
| Parking lot / library system (LLD) | OOP, SOLID, design patterns |
| Notification service | queues, retries, async processing |
| Simple chat or news feed (basic) | pub/sub, DB schema, pagination |


## Top Interview Questions Checklist

Be able to answer each in 2-3 sentences:

1. What happens when you enter a URL in the browser?
2. PUT vs PATCH vs POST? What does idempotent mean?
3. 401 vs 403?
4. Session vs JWT authentication: trade-offs?
5. How do you store passwords?
6. How does a database index work? When does it hurt?
7. Explain ACID and the isolation levels.
8. What is the N+1 problem?
9. SQL vs NoSQL: how do you choose?
10. What is caching? Explain cache-aside and invalidation.
11. How do you scale a service that is slow under load?
12. Replication vs sharding?
13. What does CAP theorem say?
14. `synchronized` vs `volatile`? What is a deadlock?
15. Why use a thread pool? `HashMap` vs `ConcurrentHashMap`?
16. Why use a message queue? What is at-least-once delivery?
17. Monolith vs microservices: when would you pick which?
18. How do you prevent SQL injection?
19. How would you design a rate limiter / URL shortener?
20. A production API is slow: how do you investigate?
