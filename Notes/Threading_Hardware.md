# Threading from Hardware Perspective

Ok so I got a rough idea how internal works:

Suppose I open Google Chrome on my laptop,

Now OS memory manager brings code of this application from SSD to RAM and keep in RAM for quick access.

There are 12 cores and 14 logical processors (execution context) in my laptop.

Chrome has configured thread for each it's operations set by development team (application threads).

Now the **OS Scheduler** assigns each application thread to its logical processor. Suppose it assigns the thread that fetches Google Chrome image to logical processor #1.

Now that logical processor acts as hardware channel where thread will execute its task.

So now it runs CPU cycles for fetching Google Chrome image.

Now comes the twist:

If that request is taking time and burning CPU cycles for CPU-intensive task or blocked for IO tasks,

But in this case, due to preemptive multitasking, suppose another application thread wants to run.

So it assigns the logical processor #1 to it, saving the state of previous operations, also known as **context switching**.

Now when that previous image-fetching process completes, it switches back to that and resumes its state and continues performing any remaining operation on it.

This happens so blazing fast that it gives the illusion that nothing has happened.

---

More application threads ≠ more performance, because each thread will compete for the same core registers, ALU, RAM, cache, etc.

### Rough Estimates

- **For CPU-intensive tasks:** Application threads = number of cores. Assigning more is not the solution.
- **For IO-intensive tasks:** Little's Law:`Concurrency = Throughput × Response Time`
  `= No. of cores × (1 + Wait Time / Service Time)`
  More so that cores don't sit idle.

---

When an application thread running on a logical processor of a core requires memory to store its execution state, it asks for RAM via `malloc()` system call.

RAM optimistically hands out a pointer if free space is available where the thread can perform writes.

Now, since RAM optimistically hands out pointers, most applications won't consume full space and will do fewer writes.

But in case some applications utilize 100% RAM such that no more space is available, it now takes action and runs **OOM (Out-of-Memory) Killer**, where it finds the application with the highest `OOM_score` and terminates it so that it won't affect other operations.
