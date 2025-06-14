[[Zettelkasten/Core vs Thread vs Process vs Program vs Task|Core vs Thread vs Process vs Program vs Task]]
## What problem does it solve?
Node.js runs on a single thread by default, so on a multi-core CPU, your server might only use one core, leaving the others idle
**Goal**: Use all CPU cores by spawning multiple processes (workers)  that can share the same server port and handle requests in parallel

> Cluster = One Primary + Multiple Workers

- Primary (or Master): Coordinates and manages workers
- Workers: Forked child processes (via child_process.fork()) that share the server port but execute code independently 

> Each worker is a fully separate process, not a thread (distinction from worker threads)

## Code Example
```ts
import cluster from 'node:cluster';
import http from 'node:http';
import { availableParallelism } from 'node:os';
import process from 'node:process';

// Determine the number of CPU cores available for parallel processing
const numCPUs = availableParallelism();

// Check if the cluster process is the primary/master process
if (cluster.isPrimary) {
  // If it is the primary process, fork a new worker process for each CPU core
  for (let i = 0; i < numCPUs; i++) {
    cluster.fork(); // This creates a new child process (worker)
  }
} else {
  // If it's worker process, create an HTTP server
  http.createServer((req, res) => {
    // Write HTTP status code 200 (OK) to the response
    res.writeHead(200);
    res.end(`Hello from worker ${process.pid}\n`);
  }).listen(8000);
}
```

> Each child (called a worker) runs independently and communicates with the parent (primary) process via IPC

## How Clustering works
1. Forking with `child_process.fork()`
	- Each worker is essentially a subprocess spawned by the primary process
	- IPC (Inter-Process communication) allows primary <=> workers to send messages and share handles.
2. Connection Handling
	There are two strategies:
	- **Round-robin**(default except on non-Windows): primary listens and delegates connections.
	- **Shared listening socket**: socket is passed to workers; they handle connections directly.

## Why cluster Express?

```nginx
Primary Process
 └─ Forks → Worker 1 (Express app on port 8000)
 └─ Forks → Worker 2 (Express app on port 8000)
 └─ Forks → ...
```

- Each worker runs its own Express instance
- The OS or Node.js distributes incoming TCP connections to available workers.
- Workers do not share memory. All communication is via IPC (`process.send()` / `worker.send()`)

### How to build Scalable Express app using cluster modules?
- One master process, multiple worker processes (equal to CPU cores) 
- Graceful shutdown of workers
- Logs to monitor process behavior

```ts
import cluster from 'node:cluster';
import os from 'node:os';
import process from 'node:process';
import express from 'express';

// Number of CPU cores
const numCPUs = os.cpus().length;

if (cluster.isPrimary) {
  console.log(`Primary ${process.pid} is running`);

  // Fork workers.
  for (let i = 0; i < numCPUs; i++) {
    cluster.fork();
  }

  // Listen for dying workers
  cluster.on('exit', (worker, code, signal) => {
    console.warn(`Worker ${worker.process.pid} died (code: ${code}, signal: ${signal})`);
    console.log('Starting a new worker');
    cluster.fork(); // Optionally restart worker
  });

} else {
  // Worker processes start Express
  const app = express();

  // Middleware
  app.use((req, res, next) => {
    console.log(`Worker ${process.pid} received request`);
    next();
  });

  // Routes
  app.get('/', (req, res) => {
    res.send(`Hello from worker ${process.pid}`);
  });

  const PORT = process.env.PORT || 3000;

  const server = app.listen(PORT, () => {
    console.log(`Worker ${process.pid} started Express on port ${PORT}`);
  });

  // Graceful shutdown (optional but recommended)
  process.on('SIGTERM', () => {
    console.log(`Worker ${process.pid} exiting`);
    server.close(() => {
      process.exit(0);
    });
  });
}
```

```
The primary(master) process is responsible for managing these workers: it forks them at startup, monitors for crashes, and restarts any that die - ensuring high availability

When incoming TCP connections arrive (e.g, HTTP requests), Node's internal cluster logic automatically load balances them across the workers using a shared server port.  

Node uses a round robin algorithm where the master process listens on the port and distributes each new connection to a worker via inter-process communication.

This setup allows multiple processes to handle concurrent requests in parallel, greatly improving throughput and making the application capable of handling much higher traffic loads than a single-threaded server.
```

> ❓If each worker runs in a thread/process, how do requests not get confused? How does the system know which worker handles which request? 

**Node.js** uses the primary process as a manager
- Starts and monitors worker processes (each one is a separate Node.js process, not just a thread)
- Internally distributes incoming network connections across the workers. 