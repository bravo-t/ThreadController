# ThreadController

## What is this?

It's a library that can suspend, resume and exit a pthread. The controller works only with threads, not processes.

This is the code snippet I came up while I was writing the multi-threaded version of [NN](https://github.com/bravo-t/NN). It contains mainly two functions, one that manipulates a control handle, which is called in main thread, the thread that creates other slave workers, and the other one called by slave threads to receive instructions from the main thread.

The code contains a self-implemented thread barrier with pthread condition variable. The reason I did it is that I met some strange behaviors with `pthread_barrier_wait`, and it's hard to debug since the source code is either assembly code, or not available. So I implemented my own thread barrier.

## Functions
### initControlHandle - Initilize the control handle struct
#### Synopsis
```c
#include "src/thread_control.h"
ThreadControl* initControlHandle(pthread_mutex_t* mutex, 
	thread_barrier_t* rdy, thread_barrier_t* ack, int number_of_threads);
```
#### Description
This function initializes a struct of `ThreadControl`, which is defined in [thread_control.h](src/thread_control.h), and returns a pointer to it. The pointer will be used as the control handle among all slave threads you want to control, and the master thread who is responsible to give instructions.
#### Return value
This function will return a valid pointer if it successes, and `NULL` pointer in case it failed.
### threadController_master - Control handle manipulator from master thread
#### Synopsis
```c
#include "src/thread_control.h"
void threadController_master(ThreadControl* handle, int inst_id);
```
#### Description
This function takes `inst_id` as the instruction about to be given to slave threads, put it into `handle`, and signal all slave threads that hold the same `handle` to execute the instruction. [thread_control.h](src/thread_control.h) already defined two macros `THREAD_RESUME` and `THREAD_EXIT` to be used as `inst_id`.
#### Return value
None
### threadController_slave - Signals slave thread to resume, or exit
#### Synopsis
```c
#include "src/thread_control.h"
void threadController_slave(ThreadControl* handle);
```
#### Description
This function listens the signal through `handle`, and execute instructions from `handle` once the instruction is available.
#### Return value
None
### Examples
The repo contains a [example.c](example.c) that illustrate how these functions are used. Please clone the repo, compile it with `make`, and execute `./example`.
Below is the code snippet from [example.c](example.c), please check it for the full code. 
In main() function, which will also be referred as the main thread:
```c
pthread_mutex_t test_mutex = PTHREAD_MUTEX_INITIALIZER;
int main() {
    int number_of_threads = 4;
    thread_barrier_t instruction_ready = THREAD_BARRIER_INITIALIZER;
    thread_barrier_t acknowledge = THREAD_BARRIER_INITIALIZER;
    ThreadControl* control_handle = initControlHandle(&test_mutex, &instruction_ready, &acknowledge, number_of_threads);
    /* Code to start slave threads */

    /* Signal slave threads to continue */
    threadController_master(control_handle, THREAD_RESUME);
    /* Signal slave threads to exit */
    threadController_master(control_handle, THREAD_EXIT);
    
    /* Code to join slave threads */
    return 0;
}
```
## License

This library is licensed under [DBAD](LICENSE.md) license. 

I don't care if you make it commercial or close-sourced, but I do care if there're any issues, or any improvements I can do to it. So if you meet any issues with it, or have anything want me to know, you are very welcomed to [create an issue](https://github.com/bravo-t/ThreadController/issues/new).
