## Tier 1 — Must know cold

**Fundamentals**
- Process vs Thread (memory model: shared heap, private stack)
- Thread lifecycle states (NEW, RUNNABLE, BLOCKED, WAITING, TERMINATED)
- `start()` vs `run()` — classic gotcha, gets asked directly

**The core problem**
- Race condition — be able to write one on the spot (shared counter, two threads, no sync)
- Critical section, atomicity vs visibility (different problems, don't conflate)

**Synchronization**
- `synchronized` (method vs block, monitor object)
- `wait()`/`notify()`/`notifyAll()` — at least explain producer-consumer conceptually, ideally code it
- Deadlock — 4 conditions, and be able to write a 2-lock deadlock example plus one fix (lock ordering)

**java.util.concurrent essentials**
- `ExecutorService` + thread pools (`newFixedThreadPool`, `newCachedThreadPool`) — why not raw `Thread` in production
- `Future`/`Callable` — how to get a return value from a thread
- `ConcurrentHashMap` vs `synchronized` HashMap — why, and segment/bucket-level locking intuition
- `CountDownLatch` — common one to be asked to use in machine coding

**Java-specific favorite**
- `volatile` — precise meaning (visibility, not atomicity), and the classic "why doesn't `volatile` fix `count++`" question

## Tier 2 — Likely, know at a working level

- `ReentrantLock` vs `synchronized` (tryLock, fairness — just the *why you'd pick one over other*, not deep API)
- Thread-safe singleton with double-checked locking — very common LLD/concurrency crossover question, ties into your existing pattern work
- Immutability as a concurrency strategy — quick to explain, sounds senior
- Executor thread pool sizing logic (CPU-bound = cores+1, I/O-bound = higher) — good one-liner answer to have ready
