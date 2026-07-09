**Layer 0 — How things talk to each other**
1. Client-server model, IP addressing, TCP vs UDP
2. DNS — how a name becomes an address
3. HTTP/HTTPS — request/response cycle, status codes, headers, REST basics
4. Synthesis: "what happens when you type a URL" — ties 1-3 together, no new concepts

**Layer 1 — Single machine basics**
5. Processes vs threads, concurrency vs parallelism (just enough to understand why one server can't do everything)
6. Databases 101 — relational vs NoSQL, ACID, normalization, indexes (B-trees, why they speed up reads)
7. Memory vs disk — why caching is even a thing

**Layer 2 — Scaling ONE service**
8. Vertical vs horizontal scaling
9. Load balancing (needs: multiple servers exist, from #8)
10. Caching layers — client, CDN, app-level, Redis/Memcached (needs: #6, #7)
11. Database replication — leader-follower, read replicas (needs: #6)
12. Database sharding/partitioning (needs: #11 — sharding is "replication wasn't enough")

**Layer 3 — Distributed systems fundamentals**
13. CAP theorem (needs: #11, #12 — meaningless without knowing what's being replicated/split)
14. Consistency models — strong vs eventual (needs: #13)
15. Consensus — Raft/Paxos at a conceptual level (needs: #14 — this is *how* systems agree on state)
16. Message queues & pub-sub — async communication (needs: #9, understanding why sync calls don't scale)

**Layer 4 — Architecture patterns**
17. Monolith vs microservices (needs: everything above — this is where it clicks why microservices exist)
18. API Gateway, service discovery
19. Rate limiting, circuit breakers, retries/backoff
20. Event-driven architecture, CQRS, event sourcing (needs: #16)

**Layer 5 — Making it reliable at scale**
21. Failover & leader election deep dive (needs: #15)
22. Cache invalidation strategies (needs: #10 — "there are only two hard problems...")
23. Observability — logging, metrics, distributed tracing
24. Auth basics — OAuth2, JWT, session vs token

**Layer 6 — Where it all comes together**
25. Back-of-envelope capacity estimation (QPS, storage, bandwidth math)
26. Case studies, in increasing complexity: URL shortener → Rate limiter → Key-value store (you've basically built this with AvailKV) → News feed → Chat system → Ride-sharing → YouTube/Netflix-scale
