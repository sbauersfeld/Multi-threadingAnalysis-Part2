#! /usr/local/cs/bin/gnuplot

# general plot parameters
set terminal png
set datafile separator ","

# Throughput vs number of threads for spin locks and mutex locks
set title "List-1: Throughput Per Number of Threads"
set xlabel "Thread Number"
set logscale x 2
set ylabel "Throughput (operations/sec)"
set logscale y 10
set output 'lab2b_1.png'

plot \
"< grep -e 'list-none-m,[0-9]*,1000,1,' lab2b_list.csv" using ($2):(1000000000/($7)) \
title 'mutex lock' with linespoints lc rgb 'red', \
"< grep -e 'list-none-s,[0-9]*,1000,1,' lab2b_list.csv" using ($2):(1000000000/($7)) \
title 'spin-lock' with linespoints lc rgb 'blue'

set title "List-2: Cost of Mutex Waits"
set xlabel "Thread Number"
set logscale x 2
set ylabel "Average time per operation (ns)"
set logscale y 10
set output 'lab2b_2.png'
plot \
"< grep 'list-none-m,[0-9]*,1000,1,' lab2b_list.csv" using ($2):($7) \
title 'time per operation' with linespoints lc rgb 'red', \
"< grep 'list-none-m,[0-9]*,1000,1,' lab2b_list.csv" using ($2):($8) \
title 'time waiting for lock' with linespoints lc rgb 'blue'

set title "List-3: Multi-list Success Rate"
set xlabel "Thread Number"
set logscale x 2
set xrange [0.75:]
set ylabel "Successful Iterations"
set logscale y 10
set output 'lab2b_3.png'
plot \
"< grep 'list-id-none,' lab2b_list.csv" using ($2):($3) \
with points lc rgb 'blue' title "Unprotected", \
"< grep 'list-id-m,' lab2b_list.csv" using ($2):($3) \
with points lc rgb 'green' title "Mutex", \
"< grep 'list-id-s,' lab2b_list.csv" using ($2):($3) \
with points lc rgb 'red' title "Spin-Lock", \

set title "List-4: Multi-list Throughput with Mutex Locking"
set xlabel "Thread Number"
set logscale x 2
set ylabel "Throughput (operations/sec)"
set logscale y 10
set output 'lab2b_4.png'
plot \
"< grep 'list-none-m,.*,1000,1,' lab2b_list.csv" using ($2):(1000000000/($7)) \
title 'lists=1' with linespoints lc rgb 'red', \
"< grep 'list-none-m,.*,1000,4,' lab2b_list.csv" using ($2):(1000000000/($7)) \
title 'lists=4' with linespoints lc rgb 'blue', \
"< grep 'list-none-m,.*,1000,8,' lab2b_list.csv" using ($2):(1000000000/($7)) \
title 'lists=8' with linespoints lc rgb 'green', \
"< grep 'list-none-m,.*,1000,16,' lab2b_list.csv" using ($2):(1000000000/($7)) \
title 'lists=16' with linespoints lc rgb 'purple', \

set title "List-5: Multi-list Throughput with Spin-lock"
set xlabel "Thread Number"
set logscale x 2
set ylabel "Throughput (operations/sec)"
set logscale y 10
set output 'lab2b_5.png'
plot \
"< grep 'list-none-s,.*,1000,1,' lab2b_list.csv" using ($2):(1000000000/($7)) \
title 'lists=1' with linespoints lc rgb 'red', \
"< grep 'list-none-s,.*,1000,4,' lab2b_list.csv" using ($2):(1000000000/($7)) \
title 'lists=4' with linespoints lc rgb 'blue', \
"< grep 'list-none-s,.*,1000,8,' lab2b_list.csv" using ($2):(1000000000/($7)) \
title 'lists=8' with linespoints lc rgb 'green', \
"< grep 'list-none-s,.*,1000,16,' lab2b_list.csv" using ($2):(1000000000/($7)) \
title 'lists=16' with linespoints lc rgb 'purple', \