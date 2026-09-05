# Java Concurrency — Interview Prep Guide



## 1. Process vs Thread

**Concept**
- **Process**: an independent execution unit with its own memory space (heap, code, data segments). OS-level isolation. Communication needs IPC (pipes, sockets, shared memory).
- **Thread**: a lightweight unit of execution *within* a process. Threads of the same process share heap and static memory, but each has its own **stack**, **program counter**, and **register set**.
- Context switching between threads is cheaper than between processes (no full memory map swap).

| Aspect | Process | Thread |
|---|---|---|
| Memory | Separate address space | Shares heap with sibling threads |
| Creation cost | High | Low |
| Communication | IPC (slow) | Shared memory (fast, but needs sync) |
| Crash isolation | One process crash doesn't affect another | One thread's unhandled error can crash the whole JVM process |

**Example**
```java
// Every Java program has at least one process (JVM) and starts with one thread: "main"
public class Demo {
    public static void main(String[] args) {
        System.out.println(Thread.currentThread().getName()); // "main"
    }
}
```

**Interview Trap Questions**
1. *"If threads share heap memory, what exactly is NOT shared between threads?"*
   → Stack, program counter, thread-local variables. Each thread has its own call stack — that's why local variables are thread-safe by default but instance/static fields aren't.
2. *"Can two threads in the same process have the same thread ID?"*
   → No, thread IDs are unique per JVM instance, but IDs *can* be reused after a thread dies and GC reclaims it.
3. *"Why is thread creation cheaper than process creation?"*
   → No new address space/page table to set up; OS just allocates a new stack and scheduling context within the existing process.
4. *"Trick question: is multithreading always faster than multiprocessing?"*
   → No — for CPU-bound work with heavy contention, thread synchronization overhead can outweigh gains; multiprocessing avoids shared-memory contention but pays IPC cost instead.



## 2. Creating a Thread in Java

**Concept**
Two classic ways:
1. Extend `Thread` and override `run()`.
2. Implement `Runnable` and pass it to a `Thread` (preferred — allows extending other classes, decouples task from execution mechanism).
3. (Modern) Implement `Callable` for tasks that return a value / throw checked exceptions — used with `ExecutorService`.
4. Lambda (since Java 8) — `Runnable` is a functional interface.

**Example**
```java
// Way 1: extending Thread
class MyThread extends Thread {
    public void run() {
        System.out.println("Running via Thread subclass: " + Thread.currentThread().getName());
    }
}

// Way 2: implementing Runnable (preferred)
class MyTask implements Runnable {
    public void run() {
        System.out.println("Running via Runnable: " + Thread.currentThread().getName());
    }
}

public class Demo {
    public static void main(String[] args) {
        new MyThread().start();
        new Thread(new MyTask()).start();
        new Thread(() -> System.out.println("Running via lambda")).start(); // Way 3
    }
}
```

**Interview Trap Questions**
1. *"Why is `Runnable` preferred over extending `Thread`?"*
   → Java has single inheritance — extending `Thread` burns your one `extends`. `Runnable` separates "what to run" from "how it runs," and works with `ExecutorService`/thread pools, unlike a raw `Thread` subclass.
2. *"Can you `start()` a `Thread` object twice?"*
   → No — throws `IllegalThreadStateException`. A `Thread` object is single-use; once it's terminated it can't be restarted.
3. *"Is `Runnable.run()` allowed to throw a checked exception?"*
   → No, `run()` returns `void` and can't declare checked exceptions. That's exactly why `Callable<V>` exists — it has `call()` returning `V` and declaring `throws Exception`.
4. *"If you implement both `Runnable` and pass it to `Thread`, and also override `run()` in a `Thread` subclass — which wins?"* (rare but asked)
   → If you extend `Thread` AND pass a `Runnable` to its constructor, the overridden `run()` in the subclass wins unless it explicitly calls `super.run()`.



## 3. start() vs run()

**Concept**
- `start()`: creates a **new OS-level thread**, which then calls `run()` on that new thread. Asynchronous.
- `run()`: just a normal method call. Executes on the **current** thread, synchronously. No new thread is created.

This is the single most common conceptual trap in Java concurrency interviews.

**Example**
```java
public class Demo {
    public static void main(String[] args) {
        Thread t = new Thread(() -> System.out.println("Thread: " + Thread.currentThread().getName()));

        t.run();    // prints "Thread: main"        -> runs on main thread!
        t.start();  // prints "Thread: Thread-0"     -> runs on a new thread
    }
}
```

**Interview Trap Questions**
1. *"What happens if you call `run()` instead of `start()`?"*
   → Code executes, but sequentially on the calling thread — no concurrency happens, no new thread is spawned. It "works" but defeats the entire purpose, and is a classic silent bug.
2. *"What happens if you call `start()` twice on the same thread?"*
   → `IllegalThreadStateException` at runtime — this is a real, checked-at-runtime failure, unlike the `run()` mistake which fails silently.
3. *"Does `start()` guarantee the new thread runs immediately?"*
   → No. `start()` only makes the thread *eligible* for scheduling; the OS/JVM thread scheduler decides when it actually gets CPU time. Order of execution across threads is not guaranteed.
4. *"Why does JVM disallow re-starting a finished thread instead of just resetting its state?"*
   → Because thread state (stack, sync locks acquired, etc.) isn't cleanly resettable; the JVM models a `Thread` as a one-shot lifecycle object by design.



## 4. Thread Lifecycle

**Concept**
`Thread.State` enum has 6 states:
1. **NEW** — created but `start()` not called.
2. **RUNNABLE** — eligible to run (may be actually running or waiting for CPU — Java doesn't distinguish "Ready" from "Running").
3. **BLOCKED** — waiting to acquire a monitor lock (`synchronized`) held by another thread.
4. **WAITING** — waiting indefinitely for another thread's signal (`Object.wait()`, `Thread.join()` w/o timeout, `LockSupport.park()`).
5. **TIMED_WAITING** — waiting for a bounded time (`sleep(ms)`, `wait(ms)`, `join(ms)`).
6. **TERMINATED** — run() completed (normally or via exception).

**Example**
```java
public class LifecycleDemo {
    public static void main(String[] args) throws InterruptedException {
        Thread t = new Thread(() -> {
            try { Thread.sleep(1000); } catch (InterruptedException e) {}
        });
        System.out.println(t.getState()); // NEW
        t.start();
        System.out.println(t.getState()); // RUNNABLE (or TIMED_WAITING if it already hit sleep)
        Thread.sleep(200);
        System.out.println(t.getState()); // TIMED_WAITING
        t.join();
        System.out.println(t.getState()); // TERMINATED
    }
}
```

**Interview Trap Questions**
1. *"Is there a 'Running' state distinct from 'Runnable' in Java's model?"*
   → No — Java's `Thread.State` merges "ready to run" and "actually running on a core" into a single `RUNNABLE` state. The OS scheduler tracks that distinction, not the JVM.
2. *"BLOCKED vs WAITING — what's the difference?"*
   → `BLOCKED` is specifically about contending for a `synchronized` monitor lock. `WAITING` is a thread that voluntarily gave up execution (via `wait()`, `join()`, `park()`) and needs another thread to notify/interrupt/unpark it.
3. *"Can a thread go from TERMINATED back to RUNNABLE?"*
   → Never. Once terminated, a `Thread` object is permanently dead — calling `start()` again throws an exception.
4. *"A thread calls `wait()` inside a `synchronized` block — what state, and does it hold the lock?"*
   → `WAITING` (or `TIMED_WAITING` if `wait(ms)`), and critically it **releases the monitor lock** while waiting — this is what makes `wait/notify` usable at all (otherwise deadlock).



## 5. sleep(), join(), interrupt()

**Concept**
- **`Thread.sleep(ms)`**: static method, pauses the *current* thread for at least `ms` milliseconds. Does **not** release any locks held.
- **`t.join()`**: caller thread waits until thread `t` finishes execution. Used to sequence thread completion.
- **`t.interrupt()`**: sets the interrupt flag on thread `t`. If `t` is blocked in `sleep/wait/join`, it throws `InterruptedException` immediately and **clears** the flag. If `t` is just running normal code, nothing happens automatically — the code must poll `isInterrupted()` itself.

**Example**
```java
public class Demo {
    public static void main(String[] args) throws InterruptedException {
        Thread worker = new Thread(() -> {
            try {
                Thread.sleep(5000);
            } catch (InterruptedException e) {
                System.out.println("Interrupted early!");
                return;
            }
            System.out.println("Finished sleeping");
        });

        worker.start();
        Thread.sleep(500);
        worker.interrupt();  // wakes worker up early via InterruptedException

        worker.join();       // main waits for worker to fully finish
        System.out.println("Main done");
    }
}
```

**Interview Trap Questions**
1. *"Does `sleep()` release the lock a thread holds?"*
   → No. This is a classic trap — `sleep()` does NOT release monitor locks, unlike `wait()`. A thread sleeping inside a `synchronized` block still blocks every other thread waiting on that lock.
2. *"What does `interrupt()` actually do to a running (non-blocked) thread?"*
   → Just sets a boolean flag. It does NOT forcibly stop anything. Cooperative cancellation only works if the thread's code checks `Thread.interrupted()` / `isInterrupted()` periodically.
3. *"After catching `InterruptedException`, is the interrupt flag still set?"*
   → No — catching `InterruptedException` clears the flag. Best practice: re-set it via `Thread.currentThread().interrupt()` inside the catch block so callers up the stack still see the interrupt.
4. *"`t1.join()` is called from `main`. If `t1` is never started, what happens?"*
   → `join()` on a thread in `NEW` state returns immediately (nothing to wait for) — it does not throw or block.
5. *"Difference between `isInterrupted()` and `Thread.interrupted()`?"*
   → `isInterrupted()` is an instance method, doesn't clear the flag. `Thread.interrupted()` is static, checks the *current* thread, and **clears** the flag as a side effect. Mixing these up is a very common bug.



## 6. What Can Go Wrong With Shared Data?

**Concept**
When multiple threads read/write the same mutable state without coordination:
- **Race conditions** — outcome depends on timing/interleaving of thread execution.
- **Visibility problems** — a thread may not see another thread's writes due to CPU caching / compiler reordering (no `happens-before` relationship).
- **Atomicity violations** — compound operations (`count++`) are not atomic; they're read-modify-write, interruptible mid-way.
- **Reordering** — JIT/CPU can reorder instructions that appear unrelated (from a single-thread perspective) but break invariants visible to other threads.

**Example**
```java
class Counter {
    private int count = 0;
    public void increment() { count++; }   // NOT atomic: read, add, write — 3 steps
    public int getCount() { return count; }
}

// Two threads calling increment() 100000 times each often produces a total < 200000
// because increments interleave and overwrite each other.
```

**Interview Trap Questions**
1. *"Is `count++` atomic in Java?"*
   → No. It's three separate bytecode operations (load, increment, store), and another thread can interleave between any of them.
2. *"If a variable is only ever written by one thread and read by many, do you still need synchronization?"*
   → Yes, potentially — for **visibility**. Without `volatile` or synchronization, readers may see a stale cached value indefinitely, even if there's no "race" on writes.
3. *"Does making a field `private` protect it from race conditions?"*
   → No — access modifiers are about encapsulation/compile-time visibility, completely orthogonal to thread safety.
4. *"Two threads increment two DIFFERENT variables, no shared state — any concurrency issue?"*
   → Generally no data race, but watch for **false sharing** (both variables on the same CPU cache line) — a performance issue, not a correctness one.



## 7. Race Condition

**Concept**
A race condition occurs when the correctness of a program depends on the relative timing of threads. Common categories:
- **Check-then-act** (e.g., `if (map.get(k) == null) map.put(k, v)` — another thread can insert between check and act).
- **Read-modify-write** (e.g., `count++`).
- **Lazy initialization without sync** (classic double-checked locking bug).

**Example**
```java
class Singleton {
    private static Singleton instance;
    public static Singleton getInstance() {
        if (instance == null) {          // Thread A and B both see null
            instance = new Singleton();  // both create separate instances!
        }
        return instance;
    }
}
```

**Interview Trap Questions**
1. *"Is a race condition the same as a bug that always reproduces?"*
   → No — that's the dangerous part. Race conditions are often non-deterministic; they may not show up in dev/testing but appear under production load. "Works on my machine" is not proof of thread safety.
2. *"How do you fix the check-then-act race above with minimal locking?"*
   → Use `ConcurrentHashMap.putIfAbsent(k, v)` — an atomic check-and-set operation — instead of manual `get()` + `put()`.
3. *"Does adding `synchronized` to just the getter but not the setter fix a race condition?"*
   → No — you must synchronize *every* access path (all readers and writers) to the shared state on the *same* lock, or you get no real protection at all.
4. *"What's the fix for the double-checked-locking singleton bug shown above?"*
   → Either synchronize the whole method (simple but slower), use the double-checked-locking pattern correctly *with* a `volatile` instance field (to prevent reordering), or use the initialization-on-demand holder idiom (a static inner class), which is lazy and thread-safe for free via JVM class-loading guarantees.



## 8. synchronized

**Concept**
`synchronized` provides **mutual exclusion** (only one thread in the critical section at a time) and establishes a **happens-before** relationship (guarantees visibility of writes made before releasing the lock to whoever acquires it next).

Two forms:
- **Method-level**: `synchronized void foo()` — locks on `this` (instance method) or the `Class` object (static method).
- **Block-level**: `synchronized(obj) { ... }` — locks on an explicit object, finer-grained.

Every Java object has an intrinsic **monitor lock**.

**Example**
```java
class Counter {
    private int count = 0;

    public synchronized void increment() {   // locks on 'this'
        count++;
    }

    private final Object lock = new Object();
    public void incrementFineGrained() {
        synchronized (lock) {                 // locks on a dedicated private object
            count++;
        }
    }
}
```

**Interview Trap Questions**
1. *"If method A is `synchronized` (instance) and method B is `synchronized static`, can they run concurrently on the same object?"*
   → Yes! Instance methods lock on `this`; static methods lock on the `Class` object — two different locks, so they don't block each other, even though it "looks" symmetric.
2. *"Is `synchronized` reentrant?"*
   → Yes — a thread already holding a lock can re-acquire it (e.g., calling another synchronized method on the same object from within a synchronized method) without deadlocking itself.
3. *"Why lock on a private final `Object` instead of `this`?"*
   → Locking on `this` exposes your lock to external code — anyone with a reference to your object can `synchronized(yourObject)` and unintentionally (or maliciously) interfere with your locking scheme. A private lock object encapsulates it.
4. *"Does `synchronized` guarantee fairness (first-come-first-served access)?"*
   → No — the JVM's default monitor lock is *not* guaranteed fair; a waiting thread could be starved in theory. `ReentrantLock(true)` is needed if fairness matters.
5. *"What happens if an exception is thrown inside a `synchronized` block?"*
   → The lock is still released — `synchronized` releases the lock automatically on both normal exit and exceptional exit (like an implicit finally).



## 9. Locks (java.util.concurrent.locks)

**Concept**
`ReentrantLock` and friends give more control than `synchronized`:
- Explicit `lock()` / `unlock()` (must be in try/finally).
- `tryLock()` — non-blocking attempt, optionally with timeout — avoids indefinite blocking.
- `lockInterruptibly()` — can respond to interrupts while waiting for the lock (`synchronized` cannot be interrupted while blocked).
- Fairness policy configurable (`new ReentrantLock(true)`).
- `ReadWriteLock` / `ReentrantReadWriteLock` — multiple concurrent readers, exclusive single writer.
- `StampedLock` (Java 8+) — adds optimistic reads, faster under read-heavy workloads.

**Example**
```java
import java.util.concurrent.locks.ReentrantLock;

class Counter {
    private final ReentrantLock lock = new ReentrantLock();
    private int count = 0;

    public void increment() {
        lock.lock();
        try {
            count++;
        } finally {
            lock.unlock();   // MUST be in finally, or a leaked lock deadlocks everything
        }
    }

    public boolean tryIncrement() {
        if (lock.tryLock()) {   // non-blocking
            try { count++; return true; }
            finally { lock.unlock(); }
        }
        return false; // couldn't get the lock, move on
    }
}
```

**Interview Trap Questions**
1. *"Why would you use `ReentrantLock` over `synchronized`?"*
   → Need `tryLock()`/timeout, interruptible lock acquisition, fairness policy, multiple `Condition` objects per lock (vs. one implicit wait-set per `synchronized` object), or non-block-scoped locking (lock in one method, unlock in another — rare, risky, but possible).
2. *"What happens if you forget `unlock()` in a `finally` block and an exception occurs?"*
   → The lock is never released — every other thread trying to acquire it blocks forever. This is a critical trap: `synchronized` can't leak this way, but explicit locks can.
3. *"Is `ReentrantLock` actually reentrant — what does that mean concretely?"*
   → A thread holding the lock can call `lock()` again without blocking itself; internally it just increments a hold count. It must call `unlock()` the same number of times to fully release it.
4. *"When would `ReadWriteLock` hurt instead of help?"*
   → Write-heavy workloads — readers still have coordination overhead, and if writes are frequent, readers rarely run concurrently anyway, so you pay ReadWriteLock's extra complexity for little benefit over a plain lock.
5. *"Can `tryLock()` cause starvation?"*
   → Yes — since it's typically non-fair by default, a thread repeatedly calling `tryLock()` and backing off can theoretically be starved by threads that keep winning the race.



## 10. volatile

**Concept**
`volatile` guarantees:
1. **Visibility** — writes to a volatile variable are immediately visible to all threads (no CPU-cache staleness); reads always go to main memory.
2. **Ordering** — prevents instruction reordering around the volatile read/write (establishes happens-before).

`volatile` does **NOT** guarantee atomicity for compound operations.

**Example**
```java
class FlagExample {
    private volatile boolean running = true;

    public void stop() { running = false; }  // visible to other threads immediately

    public void doWork() {
        while (running) {
            // do stuff — without 'volatile', this loop could run forever,
            // because the JIT might cache 'running' in a register
        }
    }
}
```

**Interview Trap Questions**
1. *"Does `volatile` make `count++` thread-safe?"*
   → No! `volatile` only fixes visibility, not atomicity. `count++` is still read-modify-write; two threads can still interleave and lose an update. Use `AtomicInteger` instead.
2. *"When is `volatile` sufficient on its own (no lock needed)?"*
   → When you have a single writer thread and multiple readers, and the variable is used independently (not combined with other state) — e.g., a simple stop flag, a "latest value" reference.
3. *"Does `volatile` on a reference make the *object it points to* thread-safe?"*
   → No — `volatile` only makes the reference assignment itself visible/ordered. If the referenced object's internal fields are mutable and unsynchronized, they're still unsafe.
4. *"What's the difference between `volatile` and `synchronized` in terms of what they guarantee?"*
   → `volatile` = visibility + ordering only, no mutual exclusion. `synchronized` = visibility + ordering + mutual exclusion (atomicity of the whole block).



## 11. AtomicInteger / Atomic Classes

**Concept**
`java.util.concurrent.atomic` package (`AtomicInteger`, `AtomicLong`, `AtomicBoolean`, `AtomicReference`, etc.) provides lock-free, thread-safe operations on single variables using **CAS (Compare-And-Swap)** hardware instructions instead of locks.
- `incrementAndGet()`, `getAndIncrement()`, `compareAndSet(expected, newVal)`, `updateAndGet(lambda)`.
- Much faster than locking under low-to-moderate contention (no OS-level blocking, no context switch).

**Example**
```java
import java.util.concurrent.atomic.AtomicInteger;

class Counter {
    private final AtomicInteger count = new AtomicInteger(0);

    public void increment() {
        count.incrementAndGet();   // atomic, lock-free
    }

    public int getCount() {
        return count.get();
    }
}
```

**Interview Trap Questions**
1. *"How does CAS work under the hood, and what's its failure mode?"*
   → CAS compares the current value to an expected value; if they match, it swaps in the new value atomically (single CPU instruction). If not, it fails and the caller typically retries in a loop (`compareAndSet` returns `false` — no exception, no blocking).
2. *"Can atomic classes fully replace locks?"*
   → No — they only protect a **single variable**. If you need to update two related variables together atomically (an invariant across both), you still need a lock or a single `AtomicReference` to an immutable composite object.
3. *"What's the ABA problem, and does `AtomicInteger` suffer from it?"*
   → ABA: a value changes from A→B→A between a thread's read and its CAS, so CAS wrongly "succeeds" thinking nothing changed. `AtomicInteger`/`AtomicReference` don't detect intermediate changes. `AtomicStampedReference` solves this by pairing the value with a version stamp.
4. *"Is `AtomicInteger` faster than `synchronized` under heavy contention?"*
   → Not necessarily — under very high contention, CAS retry loops can spin and waste CPU (livelock-ish behavior), sometimes making locks (which park waiting threads) more efficient. Atomics shine most under low-moderate contention.



## 12. ExecutorService

**Concept**
Abstraction over manual thread management — decouples "submitting a task" from "how/when it runs." Created via the `Executors` factory class or built directly with `ThreadPoolExecutor`.
Key methods: `submit()` (returns a `Future`), `execute()` (fire-and-forget), `shutdown()` (graceful), `shutdownNow()` (attempts to interrupt running tasks), `awaitTermination()`.

**Example**
```java
import java.util.concurrent.*;

public class Demo {
    public static void main(String[] args) throws Exception {
        ExecutorService executor = Executors.newFixedThreadPool(4);

        executor.execute(() -> System.out.println("Task running on " + Thread.currentThread().getName()));

        executor.shutdown(); // stop accepting new tasks, let existing ones finish
        if (!executor.awaitTermination(5, TimeUnit.SECONDS)) {
            executor.shutdownNow(); // force-interrupt remaining tasks
        }
    }
}
```

**Interview Trap Questions**
1. *"What's the difference between `shutdown()` and `shutdownNow()`?"*
   → `shutdown()` stops accepting new tasks but lets already-submitted/running tasks finish. `shutdownNow()` attempts to interrupt actively executing tasks and returns the list of tasks that were still queued but never started (no guarantee interruption actually stops them — depends on whether task code handles `InterruptedException`).
2. *"If you never call `shutdown()`, what happens to your program?"*
   → It never exits! The default thread pools use non-daemon threads, so the JVM keeps running waiting for them, even after `main()` returns. A very common "why won't my program terminate" bug.
3. *"Why is `Executors.newFixedThreadPool()` sometimes discouraged in production (per Java's own docs / static analysis tools)?"*
   → It uses an unbounded `LinkedBlockingQueue` internally — under sustained overload, tasks queue up indefinitely, risking `OutOfMemoryError` instead of failing fast. Prefer constructing `ThreadPoolExecutor` directly with a bounded queue and an explicit rejection policy.
4. *"What happens if a task submitted via `execute()` throws an uncaught exception?"*
   → The thread dies silently (pool replaces it with a new worker thread), and the exception is swallowed unless you set an `UncaughtExceptionHandler` or use `submit()` and inspect the returned `Future` (whose `get()` will re-throw it wrapped in `ExecutionException`).



## 13. Thread Pools

**Concept**
Reuses a fixed set of worker threads to execute submitted tasks, avoiding the cost of constantly creating/destroying threads. Common factory presets (via `Executors`), but understanding raw `ThreadPoolExecutor` params matters more for interviews:

```java
new ThreadPoolExecutor(
    corePoolSize, maximumPoolSize, keepAliveTime, unit,
    workQueue, threadFactory, rejectedExecutionHandler
);
```

- **`newFixedThreadPool(n)`**: core = max = n, unbounded queue.
- **`newCachedThreadPool()`**: core = 0, max = Integer.MAX_VALUE, threads die after 60s idle — good for many short-lived tasks, risky for unbounded task bursts.
- **`newSingleThreadExecutor()`**: exactly 1 thread — sequential execution guarantee, but still async from caller.
- **`newScheduledThreadPool(n)`**: supports delayed/periodic tasks.

**Example**
```java
import java.util.concurrent.*;

ThreadPoolExecutor executor = new ThreadPoolExecutor(
    2,                                  // corePoolSize
    4,                                  // maximumPoolSize
    30, TimeUnit.SECONDS,               // keepAliveTime for idle extra threads
    new ArrayBlockingQueue<>(10),       // bounded work queue
    new ThreadPoolExecutor.CallerRunsPolicy() // rejection policy: caller thread runs it itself
);
```

**Interview Trap Questions**
1. *"Walk through the exact task-scheduling algorithm of `ThreadPoolExecutor` when a new task arrives."*
   → (1) If running threads < corePoolSize, start a new thread. (2) Else, try to queue the task. (3) If the queue is full and running threads < maximumPoolSize, start a new (temporary) thread. (4) If threads are at max AND queue is full, invoke the `RejectedExecutionHandler`. Most candidates get step 2/3 ordering backwards (they think it grows to max *before* queueing).
2. *"Why is `newCachedThreadPool()` dangerous for a high-throughput service?"*
   → Unbounded max threads — a burst of tasks can spawn thousands of threads, exhausting memory/OS thread limits (each thread reserves a stack, default ~512KB–1MB), effectively a self-inflicted DoS.
3. *"What are the 4 built-in rejection policies and what do they do?"*
   → `AbortPolicy` (throws `RejectedExecutionException`, default), `CallerRunsPolicy` (task runs on the calling thread — natural backpressure), `DiscardPolicy` (silently drops), `DiscardOldestPolicy` (drops the oldest queued task, then retries submission).
4. *"Does increasing thread pool size always increase throughput?"*
   → No — for CPU-bound tasks, exceeding the number of CPU cores just adds context-switching overhead. Thread pool sizing should roughly match core count for CPU-bound work, and can be much higher for I/O-bound work (threads spend time blocked, not computing).



## 14. Callable + Future

**Concept**
- `Callable<V>`: like `Runnable` but returns a value (`V call() throws Exception`).
- `Future<V>`: a handle to an asynchronous computation's eventual result. `get()` blocks until done (or throws), `isDone()`, `cancel()`.
- `submit(Callable)` returns a `Future`; `get()` re-throws task exceptions wrapped in `ExecutionException`.

**Example**
```java
import java.util.concurrent.*;

ExecutorService executor = Executors.newFixedThreadPool(2);

Callable<Integer> task = () -> {
    Thread.sleep(1000);
    return 42;
};

Future<Integer> future = executor.submit(task);

System.out.println("Doing other work while task runs...");

try {
    Integer result = future.get(2, TimeUnit.SECONDS); // blocks up to 2s
    System.out.println("Result: " + result);
} catch (TimeoutException e) {
    future.cancel(true); // interrupt the task
}
executor.shutdown();
```

**Interview Trap Questions**
1. *"Is `future.get()` blocking or non-blocking?"*
   → Blocking (unless you use the timed overload) — it parks the calling thread until the task finishes. This is a common trap: candidates assume `Future` is inherently async everywhere, but retrieving the value is still a blocking call unless handled with callbacks (`CompletableFuture`).
2. *"If a `Callable` throws an exception, when do you find out about it?"*
   → Not immediately — it's swallowed into the `Future` and only surfaces when you call `get()`, wrapped in `ExecutionException` (use `getCause()` to get the original exception).
3. *"Does `future.cancel(true)` guarantee the task stops?"*
   → No — if the task hasn't started, it's simply prevented from starting. If it's running, `cancel(true)` interrupts the thread (sets the interrupt flag) — but the task only actually stops if its code checks for interruption or handles `InterruptedException`.
4. *"What's the core limitation of `Future` that `CompletableFuture` was designed to fix?"*
   → No way to attach a callback / chain dependent async computations — you're forced to block on `get()` to know when it's done. No composability (combine two futures), no manual completion, no built-in exception-handling pipeline.



## 15. CompletableFuture

**Concept**
Java 8+ class implementing both `Future` and `CompletionStage` — enables non-blocking, composable async pipelines with callbacks instead of blocking `get()`.

Key methods:
- `supplyAsync(Supplier)` / `runAsync(Runnable)` — start async work.
- `thenApply(fn)` — transform result (sync, on same thread as completion).
- `thenApplyAsync(fn)` — transform on a (possibly different) pool thread.
- `thenCompose(fn)` — chain another `CompletableFuture` (flatMap-style, avoids nested futures).
- `thenCombine(other, fn)` — combine two independent futures.
- `exceptionally(fn)` / `handle(fn)` — error handling.
- `allOf(...)` / `anyOf(...)` — combine multiple futures.

**Example**
```java
import java.util.concurrent.CompletableFuture;

CompletableFuture<Integer> future = CompletableFuture
    .supplyAsync(() -> fetchUserId())          // async step 1
    .thenApplyAsync(id -> fetchUserScore(id))  // async step 2, depends on step 1
    .exceptionally(ex -> {
        System.err.println("Failed: " + ex.getMessage());
        return -1; // fallback value
    });

future.thenAccept(score -> System.out.println("Final score: " + score));
// main thread is NOT blocked here — this all runs asynchronously
```

**Interview Trap Questions**
1. *"`thenApply` vs `thenApplyAsync` — what's the real difference?"*
   → `thenApply` runs the callback on whichever thread completes the previous stage (could be the calling thread if already complete, or a pool thread) — behavior can be inconsistent/surprising. `thenApplyAsync` explicitly submits the callback to the `ForkJoinPool.commonPool()` (or a custom executor if provided) — more predictable, but adds a scheduling hop.
2. *"What thread pool does `CompletableFuture` use by default, and why does that matter?"*
   → `ForkJoinPool.commonPool()`, shared JVM-wide. If you block (e.g., I/O) inside a `CompletableFuture` stage without supplying a dedicated executor, you can starve *other* unrelated parallel streams / completable futures in the app that also use the common pool.
3. *"How do you combine 5 independent `CompletableFuture`s and wait for all to finish?"*
   → `CompletableFuture.allOf(f1, f2, f3, f4, f5).join()` — note `allOf` returns `CompletableFuture<Void>`, not a list of results; you must still call `.get()` on each individual future afterward to collect results.
4. *"What happens if you don't handle exceptions in a `CompletableFuture` chain?"*
   → The exception propagates silently down the chain (subsequent `thenApply` stages are skipped) until something calls `.get()`/`.join()`, which then throws, or until an `exceptionally`/`handle` stage catches it. Forgetting error handling means silent failures downstream.
5. *"`join()` vs `get()`?"*
   → `join()` throws an unchecked `CompletionException` (no `throws` needed), `get()` throws checked `ExecutionException`/`InterruptedException`. `join()` is more common in stream/lambda chains where checked exceptions are awkward.



## 16. Deadlock / Starvation / Livelock

**Concept**
- **Deadlock**: two+ threads each hold a resource the other needs, and each waits forever. Classic cause: acquiring multiple locks in inconsistent order across threads.
- **Starvation**: a thread is perpetually denied access to a resource because other threads keep getting priority (e.g., unfair scheduling, greedy threads).
- **Livelock**: threads aren't blocked, but keep changing state in response to each other without making progress (e.g., two people repeatedly stepping aside for each other in a hallway).

**Example (Deadlock)**
```java
Object lockA = new Object();
Object lockB = new Object();

Thread t1 = new Thread(() -> {
    synchronized (lockA) {
        try { Thread.sleep(50); } catch (Exception e) {}
        synchronized (lockB) { System.out.println("t1 done"); }
    }
});

Thread t2 = new Thread(() -> {
    synchronized (lockB) {                       // opposite order from t1!
        try { Thread.sleep(50); } catch (Exception e) {}
        synchronized (lockA) { System.out.println("t2 done"); }
    }
});

t1.start(); t2.start(); // classic deadlock: t1 holds A wants B, t2 holds B wants A
```

**Interview Trap Questions**
1. *"What are the four necessary conditions for deadlock (Coffman conditions), and how does fixing lock ordering address them?"*
   → Mutual exclusion, hold-and-wait, no preemption, circular wait. Enforcing a **global, consistent lock acquisition order** (e.g., always lock the object with the smaller `hashCode()`/ID first) breaks the *circular wait* condition, which is usually the most practical one to eliminate.
2. *"How would you detect a deadlock in a running Java application?"*
   → `jstack <pid>` or `ThreadMXBean.findDeadlockedThreads()` — JVM thread dumps explicitly report "Found one Java-level deadlock" with the cycle of locks/threads involved.
3. *"Difference between livelock and deadlock in terms of thread state?"*
   → In deadlock, threads are `BLOCKED`/`WAITING` — literally stuck, consuming no CPU. In livelock, threads are `RUNNABLE` and actively burning CPU, but never make forward progress — often harder to detect because "nothing looks stuck" in monitoring.
4. *"Can `tryLock()` with a timeout fully prevent deadlock?"*
   → It prevents *indefinite* deadlock (a thread gives up and retries/backs off after a timeout) but doesn't prevent it architecturally — you can still get repeated retry storms (a form of livelock) if the backoff isn't randomized/staggered.
5. *"Is starvation possible even without any deadlock or bug in locking logic?"*
   → Yes — e.g., a non-fair `synchronized`/`ReentrantLock` under heavy contention can theoretically starve a particular thread indefinitely even though the system as a whole keeps making progress.



## 17. Java Memory Model (JMM)

**Concept**
The JMM defines the rules for how/when writes by one thread become visible to another — because modern CPUs/compilers reorder instructions and cache values per-core for performance. Without the JMM's guarantees, multithreaded code would be unpredictable across different hardware.

Core concept: **happens-before** relationship. If action A happens-before action B, then A's effects (writes) are guaranteed visible to B. Established by:
- Program order (within a single thread).
- Monitor lock: unlock happens-before subsequent lock (by any thread) on the same monitor.
- `volatile` write happens-before subsequent `volatile` read of the same variable.
- `Thread.start()` happens-before any action in the started thread.
- All actions in a thread happen-before another thread successfully returns from `Thread.join()` on it.

**Example**
```java
class SharedState {
    int a = 0;
    volatile boolean flag = false;

    // Thread 1:
    void writer() {
        a = 42;         // (1)
        flag = true;    // (2) volatile write
    }

    // Thread 2:
    void reader() {
        if (flag) {              // (3) volatile read
            System.out.println(a); // (4) guaranteed to see a == 42, NOT 0
        }
    }
}
// Without 'volatile' on flag, the JMM gives NO guarantee that Thread 2 ever
// sees flag==true, or that it sees a==42 even if it does see flag==true —
// the compiler/CPU is legally allowed to reorder (1) and (2).
```

**Interview Trap Questions**
1. *"Without any synchronization, is it legal for Thread 2 to see `flag == true` but `a == 0`?"*
   → Under the JMM, yes — this is exactly the kind of reordering the model exists to prevent. It's why "just using `volatile` on one variable" can accidentally protect *other* unrelated writes too, purely as a side effect of the happens-before edge it creates (as shown in the example above).
2. *"Does `happens-before` imply 'happens at the same real-world time' or strict ordering?"*
   → No — it's purely a *visibility/ordering guarantee* for reasoning about memory effects, not a claim about wall-clock timing. Two actions with no happens-before relationship can even be considered to have happened "simultaneously" from the JMM's perspective.
3. *"Why can't you rely on `System.out.println` or debugging to 'prove' a lack of race condition?"*
   → JMM bugs are often timing/hardware-dependent (different results on different CPU architectures, JIT optimization levels) — passing a test on your laptop proves nothing about production hardware or JIT behavior under load.
4. *"Is final field visibility guaranteed without synchronization?"*
   → Yes, specially — the JMM guarantees that once a constructor finishes, any thread that gets a reference to the fully-constructed object sees the correctly initialized values of its `final` fields (assuming no reference "leaks" out of the constructor before it completes — the classic *unsafe publication* trap).



## 18. Concurrent Collections

**Concept**
`java.util.concurrent` collections designed for safe concurrent access without external locking, generally outperforming `Collections.synchronizedX()` wrappers under contention:

| Collection | Notes |
|---|---|
| `ConcurrentHashMap` | Segment/bucket-level locking (not whole-map lock); `putIfAbsent`, `computeIfAbsent` are atomic |
| `CopyOnWriteArrayList` | Every write copies the whole underlying array; reads never block, ideal for read-heavy/rarely-written lists (e.g., listener lists) |
| `BlockingQueue` (`ArrayBlockingQueue`, `LinkedBlockingQueue`) | `put()` blocks if full, `take()` blocks if empty — backbone of producer-consumer patterns |
| `ConcurrentLinkedQueue` | Lock-free (CAS-based), non-blocking, unbounded |
| `ConcurrentSkipListMap` | Concurrent sorted map, O(log n) operations |

**Example**
```java
import java.util.concurrent.*;

// Producer-consumer with BlockingQueue
BlockingQueue<Integer> queue = new ArrayBlockingQueue<>(10);

Thread producer = new Thread(() -> {
    for (int i = 0; i < 20; i++) {
        try { queue.put(i); } catch (InterruptedException e) {}
    }
});

Thread consumer = new Thread(() -> {
    while (true) {
        try {
            Integer val = queue.take(); // blocks if empty
            System.out.println("Consumed: " + val);
        } catch (InterruptedException e) { break; }
    }
});

producer.start(); consumer.start();

// ConcurrentHashMap atomic operations
ConcurrentHashMap<String, Integer> map = new ConcurrentHashMap<>();
map.putIfAbsent("count", 0);
map.computeIfPresent("count", (k, v) -> v + 1); // atomic read-modify-write
```

**Interview Trap Questions**
1. *"Does `ConcurrentHashMap` lock the entire map during a `put()`?"*
   → No (since Java 8) — it uses fine-grained locking at the bin/node level (and CAS for common cases), allowing high concurrent throughput. Older (Java 7) versions used segment-level locking (16 segments by default) — still not a single global lock.
2. *"Why does `CopyOnWriteArrayList` throw `UnsupportedOperationException`... wait, no — what does its iterator actually do under concurrent modification?"*
   → Its iterator works on a **snapshot** of the array taken at iterator-creation time — it will NOT throw `ConcurrentModificationException` (unlike `ArrayList`), but it also won't reflect concurrent modifications made after the snapshot; it's a fixed, stale view.
3. *"`Collections.synchronizedMap()` vs `ConcurrentHashMap` — when would you still choose the former?"*
   → Rarely — mainly legacy code compatibility. `synchronizedMap` locks the *entire* map on every operation (coarse-grained), and even "atomic-looking" compound operations like check-then-put still need external synchronization on the map object, unlike `ConcurrentHashMap`'s built-in atomic methods.
4. *"Is `ConcurrentHashMap` iteration guaranteed to reflect a consistent snapshot?"*
   → No — its iterators are **weakly consistent**: they reflect the state at some point during iteration, may or may not show updates made during iteration, and never throw `ConcurrentModificationException`. This is a common confusion point vs. fail-fast iterators on `HashMap`.
5. *"When is `CopyOnWriteArrayList` a bad choice?"*
   → Write-heavy workloads — every single write (`add`, `remove`, `set`) copies the *entire* backing array, which is O(n) per write and can be catastrophic for large, frequently-mutated lists.



## Quick Reference — Cross-Cutting Trap Themes

These recur across almost every topic above, so interviewers love pairing them with any question:

- **"Does X make the operation atomic?"** — the recurring gotcha is confusing *visibility* (`volatile`) with *atomicity* (`synchronized`/locks/atomics). They are NOT the same guarantee.
- **"Does X guarantee ordering, or just eventual correctness?"** — happens-before is about ordering guarantees, not timing guarantees.
- **"What happens on exception inside a critical section?"** — `synchronized` auto-releases; explicit `Lock` does NOT unless you use try/finally.
- **"Is this thread-safe under high contention, or just 'usually works'?"** — always ask about worst-case interleaving, not the happy path.
- **"Blocking vs non-blocking"** — `Future.get()` blocks, `CompletableFuture` callbacks don't; `synchronized`/`ReentrantLock.lock()` block, `tryLock()`/atomics don't (or fail fast).
