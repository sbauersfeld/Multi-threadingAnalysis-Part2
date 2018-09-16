# Multi-threadingAnalysis-Part2
An analysis of the efficiency of various locking mechanisms on a hash-based list structure that is designed to improve multi-threaded performance over a traditional list. Performance measurements were recorded in a csv file, which was then used to create graphs to visualize the data. Additionally, gprof was used to analyze the percent of time spent checking spin locks.

The following is a series of questions and answers regarding the analysis of the data shown in the data graphs.


QUESTION 2.3.1 - Cycles in the basic list implementation:
Where do you believe most of the cycles are spent in the 1 and 2-thread list tests ?
Why do you believe these to be the most expensive parts of the code?
Where do you believe most of the time/cycles are being spent in the high-thread spin-lock tests?
Where do you believe most of the time/cycles are being spent in the high-thread mutex tests?

Most of the cycles in the 1 and 2-thread tests are being spent performing list operations.

This is because the operations that update the linked list structure are much more expensive than
simply checking if a lock is open. In the case of 1 and 2-threads, there is a relatively small chance
of contention so there are not many cycles being spent checking the locks. With fewer threads, there
are also fewer context switches.

In the high thread spin lock cases, most of the time is spent checking the spin lock because there is
a large amount of contention for each lock. Each thread must therefore spend many cycles checking the lock.

In the high-thread mutex lock cases, most of the time is spent performing operations on the list or
doing context switches. This is because mutex locks put waiting threads to sleep, so they do not waste
as many cycles checking to see if the lock is open. List operations consume the most time particularly for
long lists, but context switches may take longer if there are a large enough number of threads working on
a small list.

QUESTION 2.3.2 - Execution Profiling:
Where (what lines of code) are consuming most of the cycles when the spin-lock version of the list exerciser is run with a large number of threads?
Why does this operation become so expensive with large numbers of threads?

The lines of code that check the spin-lock are consuming the majority of the cycles.

This operation is expensive with a large number of threads because there is a large amount of contention
for each lock. If a thread cannot acquire a lock, it continues to spin until it either acquires the lock
or is switched out for another thread. Because only one thread can hold the lock and there are many threads
spinning for the same lock, a lot of CPU cycles are wasted by those spinning threads. This problem is exacerbated
if the thread holding the lock is switched out for a thread that is spin-waiting, because no progress is being
made towards releasing the lock.

QUESTION 2.3.3 - Mutex Wait Time:
Look at the average time per operation (vs. # threads) and the average wait-for-mutex time (vs. #threads).
Why does the average lock-wait time rise so dramatically with the number of contending threads?
Why does the completion time per operation rise (less dramatically) with the number of contending threads?
How is it possible for the wait time per operation to go up faster (or higher) than the completion time per operation?

The average lock-wait time rises with increasing numbers of threads because only one thread can ever hold
the lock at once. The added contention from more threads therefore results in a large wait time because
the rest of the threads must wait for the lock to be released.

The completion time per operation rises with the number of threads because there is greater overhead from
context switches and wasted time from locking. However, the rise is less dramatic because the average wait
time is dependent only upon the time that threads wait to acquire a lock, while the time per operation depends
upon many other factors as well.

The wait time per operation may go up faster than the completion time per operation because the completion time
simply measures the time it takes for the entire program to complete. On the other hand, the wait time measures
the time that each thread is waiting for a lock and multiple threads may be running at once. In this case, the
completion time would not take into account the fact that multiple threads are running at once, while the wait
time would essentially be multiplied by the number of parallel running threads.

QUESTION 2.3.4 - Performance of Partitioned Lists
Explain the change in performance of the synchronized methods as a function of the number of lists.
Should the throughput continue increasing as the number of lists is further increased? If not, explain why not.
It seems reasonable to suggest the throughput of an N-way partitioned list should be equivalent to the throughput
of a single list with fewer (1/N) threads. Does this appear to be true in the above curves? If not, explain why not.

As the number of lists increases, the contention for each lock decreases and the performance increases. In addition,
each list is likely to be shorter so the operations on each list is shorter.

No, at some point, increasing the number of lists will no longer improve the throughput. This is because there will
be a point at which there are enough threads to practically eliminate contention, and adding more lists will only
increase the overhead of creating and destroying them.

No, the throughput of a N-way partitioned list is greater than the alternative because increasing the number of lists
allows for multiple threads to be working on different lists in parallel. With reduced contention due to smaller lists
and a greater number of lists, each thread is able to spend much less time waiting for a lock than in the case of 1/N
threads.
