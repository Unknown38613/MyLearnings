# Java Multithreading – Interview Preparation Topics

## 1. Process vs Thread

- Process: A program that runs on isolated memory so multiple programs can run independently. Even if one crashes, the others remain unaffected.

- Trade-off: Creating a process requires memory allocation, and switching between processes requires swapping between memory mappings.

- Threads: Lightweight execution units of processes, where all threads in a process share the same heap memory but have private stacks for local variables and system calls.

- Trade-off: Fast to create and easy to switch. However, a race condition can occur when two threads try to modify the same data in shared memory, which might lead to a process crash.

## 2. Concurrency vs Parallelism

- Concurrency: Structure code for managing multiple tasks at once, even on a single CPU core, by rapidly switching between tasks when they are finished, blocked, idle, etc.

- Parallelism: Relies on multi-core hardware, where multiple tasks are handed over to multiple cores for execution at the same time.

## 3. Thread, Runnable, Callable

### "What is the difference between `Thread`, `Runnable`, and `Callable` in Java?"

Your Answer:

- "At a high level, `Thread` is the actual worker that executes code, while `Runnable` and `Callable` represent the job that needs to be done.

- A `Runnable` is a functional interface with a `run()` method. It’s used for fire-and-forget tasks because `run()` returns `void` and cannot throw checked exceptions. You pass a `Runnable` into a `Thread` or an `ExecutorService` to run it.

- A `Callable` is an upgraded version of `Runnable` introduced for tasks that need to send data back. Its `call()` method returns a generic value and can throw checked exceptions. Since it runs in the background, you submit it to an `ExecutorService` and get a `Future` object back to retrieve the result once it’s ready.

- In real-world Java, we avoid extending the `Thread` class directly because Java doesn't support multiple inheritance, and extending `Thread` tightly couples our business logic to the thread lifecycle. Instead, we separate the task (`Runnable` or `Callable`) from the execution by submitting tasks to a thread pool via `ExecutorService`."

### Likely Follow-Up: "Why use `Runnable` instead of extending `Thread`?"

Your Answer:

- "Two main reasons:

1. Separation of concerns: `Runnable` defines what needs to be done, while `Thread` or a thread pool handles how and when it runs. You can reuse the same `Runnable` task across multiple threads or thread pools.

2. Inheritance: Java only allows single class inheritance. If you extend `Thread`, your class cannot extend anything else. Implementing `Runnable` leaves your class free to extend another base class."

## 4. start() vs run(), join(), sleep()

- "**`start()` vs `run()`:** `start()` asks the JVM to spin up a **new OS thread** and run the task asynchronously. Calling `run()` directly just executes it like a regular method on the **current thread** with no concurrency.
- **`join()`:** Used for thread coordination. When Thread A calls `threadB.join()`, **Thread A pauses** and waits until Thread B completely finishes its execution.
- **`sleep()` vs `wait()`:** Both pause the current thread, but with a critical difference in locking:
- * **`Thread.sleep()`** pauses for a fixed time and **keeps all locks** it holds.
- * **`Object.wait()`** pauses until another thread calls `notify()`, and it **releases the lock** so other threads can access the shared resource."

### Quick Cheat-Sheet for Rapid-Fire Follow-Ups

* **Can you call `start()` twice on the same thread?** No, it throws `IllegalThreadStateException`.
* **Which thread pauses on `t.join()`?** The *calling* thread pauses, not `t`.
* **Why is `wait()` in `Object` instead of `Thread`?** Because in Java, every object has an intrinsic lock (monitor), and `wait()` releases that specific object's lock.

## 5. Thread Lifecycle

## 6. ExecutorService and Thread Pools

## 7. Future and Callable

## 8. Race Conditions and Critical Sections

## 9. synchronized and Object/Class Locks

## 10. volatile and AtomicInteger

## 11. Deadlock and Starvation

## 12. wait(), notify(), notifyAll()

## 13. ReentrantLock

## 14. CountDownLatch and Semaphore

## 15. BlockingQueue and Producer-Consumer

## 16. ConcurrentHashMap

## 17. CompletableFuture

## 18. Thread Safety and Thread Pool Sizing

## 19. Virtual Threads (Basic Understanding)
