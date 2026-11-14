Redis:
redis is a in-memory datastore, which is blazing fast because it operates on RAM, and RAM is optimized to perform any read-write operation in nanoseconds which allows redis to scale upto 1 million QPS, also it runs on single CPU thread so it doesn't have bottlenecks like context switching, deadlocks, concurrency issues, etc also it uses I/O multiplexing, means instead of assigning new thread to each request, it relies on event loop by OS kernel like epoll for monitoring every socket connection established by clients on redis server, then if data packet arrives it immediately performs operations and frees up the socket

How does redis achieves it?
It uses its own redis object which prevents heavy objects overhead,
uses its own dynamic data structures like listpack, intset which eliminates use of pointers
uses its own memory allocator jemalloc made for small to medium size object fragmentation 
uses maxmemory and eviction policies so that it uses assigned memory only and prevent stales

OS bottleneck - cpu overutilization, context switching, concurrency, memory overhead, handled by single thread, IO multiplexing, RAM
Network bottleneck - network RTT, TCP connection overhead handled by batching network calls, many commands in single TCP packet, redis execute it in loop and return combined response
Scaling bottleneck - millions of concurrent requests handled by redis cluster, 16384 hash slots, read replicas for each master shard

