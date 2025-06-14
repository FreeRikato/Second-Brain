A **program** is a passive collections of instructions stored on disk (like a `.exe` or `.py`), while a **process** is an active instance of a program in execution, with its own memory space and system resources.

A **subroutine**, also called a function or procedure, is a reusable block of code within a program or thread that performs a specific operation and can be called multiple times during execution, but it's not an independently schedulable unit like a thread or process.

A **thread** is the smallest unit of execution within a process and shares the same memory space with other threads in that process; multiple threads in a process can run concurrently.

A **task** is a more general or abstract term that often refers to a unit of work, which could be a thread, process or even a subroutine, depending on the context (in operating system or scheduling).

A **core** refers to a physical processing unity within a CPU capable of executing tasks (processes or threads); modern CPUs have multiple cores that enable parallel execution of multiple threads or processes simultaneously.

In essence: a core runs threads, threads belong to process, processes are instances of programs, tasks are the work scheduled for execution, and subroutines are blocks of code within a program or thread that perform specific functions when called