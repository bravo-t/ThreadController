PRE_CFLAGS = -g -O0
CC=gcc
LIBS=-lpthread -lrt
CFLAGS=$(PRE_CFLAGS) -std=gnu99 -Wall

default: example

example: example.c thread_barrier.o thread_control.o
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)

thread_barrier.o: src/thread_barrier.c
	$(CC) -c -o $@ $< $(CFLAGS) $(LIBS)

thread_control.o: src/thread_control.c
	$(CC) -c -o $@ $< $(CFLAGS) $(LIBS)
