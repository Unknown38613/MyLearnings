# Threading from Hardware Perspective

Ok so i got a rough idea how internal works:

Suppose i open Google Chrome on my laptop,

Now RAM brings code of this application from SSD to RAM and keep in RAM for quick access.

There are 12 cores and 14 logical processors (hyper-threading) in my laptop.

Chrome has configured thread for each its operations set by development team (application threads).

Now the "OS Scheduler" assigns each application thread to its logical processor. Suppose it assigns the thread that fetches Google Chrome image to logical processor #1.

Now that logical processor acts as hardware channel where thread will execute its task.

So now it runs CPU cycles for fetching Google Chrome image.

Now comes the twist:

If that request is taking time and burning CPU cycles for CPU-intensive task or sitting idle for IO tasks,

But in this case due to preemptive multitasking, suppose another application thread wants to run.

So it assigns the logical processor #1 to it, saving the state of previous operations, also known as context switching.

Now when that previous image fetching process completes, it switches back to that and resumes its state and continues performing any remaining operation on it.

This happens so blazing fast that it gives illusion that nothing has happened.

More application threads is not equals more performance, because each thread will compete for same core registers, ALU, RAM, cache etc.

**Rule of thumb:**
- For CPU-intensive task: application thread = number of cores, assigning more is not solution.
- For IO-intensive task: Little's Law = number of cores × (1 + wait time/service time), more so that cores don't sit idle.

When application thread running on logical processor of core requires memory to store its execution state, it asks for RAM via `malloc()` system call, RAM optimistically hands out pointer if free space is available where thread can perform writes.

Now since RAM optimistically hands out pointer, most of application won't consume full space and will do fewer writes, but in case if some applications utilizes 100% RAM such that no more space is available, it now takes action and runs OOM (Out-of-memory) killer, where it finds application with highest `oom_score` and terminates it so that it won't affect other operations.
