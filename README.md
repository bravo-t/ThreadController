# ThreadController

## What is this?

It's a library that can suspend, resume and exit a pthread. The controller works only with threads, not processes.

This is the code snippet I came up while I was writing the multi-threaded version of [NN](https://github.com/bravo-t/NN). It contains mainly two functions, one that manipulates a control handle, which is called in main thread, the thread that creates other slave workers, and the other one called by slave threads to receive instructions from the main thread.

The code contains a self-implemented thread barrier with pthread condition variable. The reason I did it is that I met some strange behaviors with `pthread_barrier_wait`, and it's hard to debug since the source code is either assmebly code, or not available. So I implemented my own thread barrier.

## Usage

I will add it later

## License

This library is licensed under [DBAD](LICENSE.md) license. 

I don't care if you make it commercial or close-sourced, but I do care if there're any issues, or any improvements I can do to it. So if you meet any issues with it, or have anything want me to know, you are very welcomed to [create an issue](https://github.com/bravo-t/ThreadController/issues/new).
