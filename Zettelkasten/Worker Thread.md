JS code in Node.js  runs on a single thread (main thread). This is managed by the event loop.

![[Files/Pasted image 20250613182954.png]]

> This is fine for I/O -bound work because Node uses asynchronous, non-block I/O:
```
When you perform an I/O operation (like reading a file or making a network task), Node.js hands that task off to the operating system. It doesn't wait. It continues executing other code and checks back later to see if the I/O is done. This is called non-blocking I/O, and it's why Node.js is fantastic for I/O intensive applications (like web servers)
```

## The Bottleneck: CPU-intensive tasks
❓What happens if a task cannot be handed off to the OS? This is a CPU-intensive or CPU-bound task, like complex calculations, image processing, or heavy data parsing

![[Files/Pasted image 20250613183250.png]]

> The event loop is blocked and the entire application becomes unresponsive. No new requests can be handled, no timers will fire, nothing happens until the CPU-intensive task is complete 

## The Solution: Parallel Execution with Worker Threads

Worker threads allow to create additional threads within the same Node.js process to run JavaScript in parallel, 
- Offload a heavy, CPU-bound task to worker thread
- Main thread's event loop remains unblocked and free to handle other tasks (like responding to HTTP requests)
- The worker thread performs the heavy computation and sends the result back to the main thread when it's done

## How do worker threads work?
With `new Worker()`, Node.js starts up a new thread with its own independent:
- V8 Engine Instance: It has it own JavaScript engine.
- Event loop: It has its own Event loop, separate from the main thread's
- Memory space: By default, it has it own memory. This is crucial for preventing race conditions and making them easier to reason about than traditional multi-threaded programming. 

> Communication between threads happens not by directly accessing each other's variable, but through a safe, structured message-passing system.

## Worker threads vs Cluster modules

| Feature | `worker_threads` | `cluster` |
| :--- | :--- | :--- |
| **Unit of Parallelism** | **Threads** within a single process. | **Processes**, each with its own memory space and event loop. |
| **Underlying Tech** | V8 Isolates. | `child_process.fork()`. |
| **Weight** | **Lightweight**. Lower startup time and memory overhead. | **Heavyweight**. Spawning a new process is more resource-intensive. |
| **Memory Sharing** | **Yes**. Can transfer (`ArrayBuffer`) or truly share memory (`SharedArrayBuffer`). | **No**. Memory is isolated. Communication is via IPC (slower). |
| **Primary Use Case** | **CPU-bound tasks**. Offload heavy computations to keep the main event loop free. | **I/O-bound tasks**. Scale a network server (e.g., an HTTP server) across multiple CPU cores to handle more concurrent connections. |
| **Analogy** | A team of specialists working in the same office, passing memos to each other. | Multiple separate branch offices, communicating via mail. |
> ✅ Use **Workers** for CPU-heavy tasks. Use **Cluster** to scale a network server across multiple cores.

