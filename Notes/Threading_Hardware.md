# Threading from Hardware Perspective

Ok, so I got a rough idea of how things work internally.

Suppose I open Google Chrome on my laptop.

The OS loads the required parts of Chrome from SSD into RAM so the CPU can access them quickly.

There are 12 physical cores and 14 logical processors (hardware threads) in my laptop.

Chrome creates multiple application threads to handle different operations, such as fetching data, processing requests and handling UI activities.

Now the OS Scheduler assigns runnable application threads to available logical processors. Suppose it assigns the thread responsible for processing a Google Chrome image to logical processor #1.

Now that logical processor acts as a hardware execution channel where the thread's instructions get executed.

So the CPU executes instructions using its available resources (CPU cycles, ALU, registers, etc.).

Now comes the twist:

Suppose that thread requests an image from a server. It sends the request and waits for the network response. During this time, it doesn't need to continuously consume CPU cycles.

The OS marks that thread as waiting (blocked), and the scheduler can assign logical processor #1 to another runnable thread.

Similarly, if a CPU-intensive thread is running, the OS can pause it after its allocated execution time and schedule another runnable thread. This is called preemptive multitasking.

While switching threads, the OS saves the previous thread's execution state (context switching), so it can resume from where it stopped.

When the image response arrives, the waiting thread becomes runnable again and gets CPU time when the scheduler selects it.

This happens so quickly that it gives the illusion that multiple things are happening simultaneously, even when multiple threads are sharing the same execution resources.

**More application threads ≠ more performance**, because threads compete for CPU execution resources, registers, cache, memory bandwidth, etc. Too many threads can also introduce context-switching overhead.

**Rule of thumb:**

- For CPU-intensive tasks: Start with approximately one worker thread per available physical core. More threads aren't necessarily better because they compete for the same CPU resources.
- For IO-intensive tasks: We can have more threads than CPU cores because some threads spend time waiting for IO while others can use the CPU. Little's Law gives a rough starting point for estimating concurrency:

  `Concurrency ≈ Throughput × Response Time`

  Alternatively, for a CPU-based workload with IO waiting:

  `Threads ≈ Number of CPU cores × (1 + Wait Time / Service Time)`

  This is an approximation, not a universal rule. Actual thread count depends on workload, memory, latency and resource limits.

**Memory management:**

When an application needs memory to store its data and execution state, it requests memory through its memory allocator (for example, using malloc() in C or the JVM managing heap memory in Java).

The allocator may obtain memory from the OS and return an address where the application can store data.

Modern operating systems may optimistically allocate virtual memory without immediately reserving equivalent physical RAM.

If applications consume too much memory and the system comes under severe memory pressure, the OS may take action. On Linux, the OOM (Out-of-Memory) killer can terminate a process based on factors such as its OOM score to free memory and protect the system.
