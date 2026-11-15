1. Process vs Thread - 
   Process: program that runs on isolated memory so multiple programs can run independently, even if one crashes other remains unaffected, trade off- creating process requires memory allocation and switching between process requires swapping between memory mappings
   Threads: lightweight execution unit of processes, where all thread is process shares same heap memory, but have private stack for local variable and system calls, fast to create, easy to switch, trade off - Race condition when 2 thread tries to modify same data in shared memory, might lead to process crash
   
2. Concurrency vs Parallelism -
   Concurrency: structure code for managing multiple task at once even on single CPU core, by rapidly switching between tasks when they are finished, blocked, idle, etc
   Parallelism: relies on multi-core hardware, were multiple tasks are handed over to multiple cores for execution at same time
   
3. Thread, Runnable, Callable
6. start() vs run(), join(), sleep()
7. Thread Lifecycle
8. ExecutorService and Thread Pools
9. Future and Callable
10. Race Conditions and Critical Sections
11. synchronized and Object/Class Locks
12. volatile and AtomicInteger
13. Deadlock and Starvation
14. wait(), notify(), notifyAll()
15. ReentrantLock
16. CountDownLatch and Semaphore
17. BlockingQueue and Producer-Consumer
18. ConcurrentHashMap
19. CompletableFuture
20. Thread Safety and Thread Pool Sizing
21. Virtual Threads (Basic Understanding)
