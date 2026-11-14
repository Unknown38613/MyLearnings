# Redis:

redis is a in-memory datastore, which is blazing fast because it operates on RAM, and RAM is optimized to perform any read-write operation in nanoseconds which allows redis to scale upto 1 million QPS, also it runs on single CPU thread so it doesn't have bottlenecks like context switching, deadlocks, concurrency issues, etc also it uses I/O multiplexing, means instead of assigning new thread to each request, it relies on event loop by OS kernel like epoll for monitoring every socket connection established by clients on redis server, then if data packet arrives it immediately performs operations and frees up the socket

## How does redis achieves it?

- It uses its own redis object which prevents heavy objects overhead,
- uses its own dynamic data structures like listpack, intset which eliminates use of pointers
- uses its own memory allocator jemalloc made for small to medium size object fragmentation
- uses maxmemory and eviction policies so that it uses assigned memory only and prevent stales

## OS bottleneck

- cpu overutilization, context switching, concurrency, memory overhead, handled by single thread, IO multiplexing, RAM

## Network bottleneck

- network RTT, TCP connection overhead handled by batching network calls, many commands in single TCP packet, redis execute it in loop and return combined response

## Scaling bottleneck

- millions of concurrent requests handled by redis cluster, 16384 hash slots, read replicas for each master shard

## Cache Aside Pattern (Lazy Loading)

cache hit and cache miss

## TTL (doesn't guarantee fresh data)

## Cache update strategy:

- TTL expiration : set expiry time, auto remove after expiry
- Cache invalidation: when DB data changes, delete corresponding cache key next request fetch new data
- Cache update: after DB update redis key with fresh data
- write-through : every write goes to both DB and Redis synchronously

how to handle concurrency and race conditions in it (application level race conditions): use redis distributed locks

## caching problems and their solutions for redis:

- cache stampede: Multiple requests hit DB when a popular key expires. Use distributed locks, request coalescing, or randomized TTL.
- cache penetration: Requests for non-existent data repeatedly hit DB. Cache null results with short TTL or use a Bloom filter.
- cache avalanche: Many keys expire simultaneously, overwhelming DB. Use randomized TTLs and staggered expiration.
- stale data: Cache contains outdated data after DB updates. Use cache invalidation, write-through, or version-based updates.
- hot key: One Redis key receives extremely high traffic. Use local caching, key replication, or request throttling.
