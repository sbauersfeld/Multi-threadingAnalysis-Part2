
default: build

build:
	gcc -g -Wall -Wextra -o lab2_list lab2_list.c SortedList.c -lpthread -lprofiler

dist: build tests graphs profile
	tar -czvf lab2b.tar.gz README Makefile SortedList.c lab2_list.c SortedList.h *.png *.csv *.gp profile.out

clean:
	rm -rf lab2_list lab2b.tar.gz

graphs:
	chmod +x lab2b_list.gp
	./lab2b_list.gp 

profile: build
	CPUPROFILE=profile.gperf ./lab2_list --threads=12 --iterations=1000 --sync=s
	pprof --text ./lab2_list profile.gperf > profile.out
	pprof --list=threader ./lab2_list profile.gperf >> profile.out
	rm -f profile.gperf

tests:
	./lab2_list --threads=1  --iterations=1000 --sync=m > lab2b_list.csv
	./lab2_list --threads=2  --iterations=1000 --sync=m >> lab2b_list.csv
	./lab2_list --threads=4  --iterations=1000 --sync=m >> lab2b_list.csv
	./lab2_list --threads=8  --iterations=1000 --sync=m >> lab2b_list.csv
	./lab2_list --threads=12 --iterations=1000 --sync=m >> lab2b_list.csv
	./lab2_list --threads=16 --iterations=1000 --sync=m >> lab2b_list.csv
	./lab2_list --threads=24 --iterations=1000 --sync=m >> lab2b_list.csv
	./lab2_list --threads=1  --iterations=1000 --sync=s >> lab2b_list.csv
	./lab2_list --threads=2  --iterations=1000 --sync=s >> lab2b_list.csv
	./lab2_list --threads=4  --iterations=1000 --sync=s >> lab2b_list.csv
	./lab2_list --threads=8  --iterations=1000 --sync=s >> lab2b_list.csv
	./lab2_list --threads=12 --iterations=1000 --sync=s >> lab2b_list.csv
	./lab2_list --threads=16 --iterations=1000 --sync=s >> lab2b_list.csv
	./lab2_list --threads=24 --iterations=1000 --sync=s >> lab2b_list.csv

	./lab2_list --threads=1  --iterations=1   --yield=id    --lists=4	      >> lab2b_list.csv
	./lab2_list --threads=1  --iterations=2   --yield=id    --lists=4	      >> lab2b_list.csv
	./lab2_list --threads=1  --iterations=4   --yield=id    --lists=4	      >> lab2b_list.csv
	./lab2_list --threads=1  --iterations=8   --yield=id    --lists=4	      >> lab2b_list.csv
	./lab2_list --threads=1  --iterations=16   --yield=id    --lists=4	      >> lab2b_list.csv

	-./lab2_list --threads=4  --iterations=1   --yield=id    --lists=4	      >> lab2b_list.csv
	-./lab2_list --threads=4  --iterations=2   --yield=id    --lists=4	      >> lab2b_list.csv
	-./lab2_list --threads=4  --iterations=4   --yield=id    --lists=4	      >> lab2b_list.csv
	-./lab2_list --threads=4  --iterations=8   --yield=id    --lists=4	      >> lab2b_list.csv
	-./lab2_list --threads=4  --iterations=16   --yield=id    --lists=4	      >> lab2b_list.csv
	-./lab2_list --threads=8  --iterations=1   --yield=id    --lists=4	      >> lab2b_list.csv
	-./lab2_list --threads=8  --iterations=2   --yield=id    --lists=4	      >> lab2b_list.csv
	-./lab2_list --threads=8  --iterations=4   --yield=id    --lists=4	      >> lab2b_list.csv
	-./lab2_list --threads=8  --iterations=8   --yield=id    --lists=4	      >> lab2b_list.csv
	-./lab2_list --threads=8  --iterations=16   --yield=id    --lists=4	      >> lab2b_list.csv
	-./lab2_list --threads=12  --iterations=1   --yield=id    --lists=4	      >> lab2b_list.csv
	-./lab2_list --threads=12  --iterations=2   --yield=id    --lists=4	      >> lab2b_list.csv
	-./lab2_list --threads=12  --iterations=4   --yield=id    --lists=4	      >> lab2b_list.csv
	-./lab2_list --threads=12  --iterations=8   --yield=id    --lists=4	      >> lab2b_list.csv
	-./lab2_list --threads=12  --iterations=16  --yield=id    --lists=4	      >> lab2b_list.csv
	-./lab2_list --threads=16  --iterations=1   --yield=id    --lists=4	      >> lab2b_list.csv
	-./lab2_list --threads=16  --iterations=2   --yield=id    --lists=4	      >> lab2b_list.csv
	-./lab2_list --threads=16  --iterations=4   --yield=id    --lists=4	      >> lab2b_list.csv
	-./lab2_list --threads=16  --iterations=8   --yield=id    --lists=4	      >> lab2b_list.csv
	-./lab2_list --threads=16  --iterations=16  --yield=id    --lists=4	      >> lab2b_list.csv

	./lab2_list --threads=1  --iterations=10   --yield=id    --lists=4    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=1  --iterations=20   --yield=id    --lists=4    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=1  --iterations=40   --yield=id    --lists=4    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=1  --iterations=80   --yield=id    --lists=4    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=4  --iterations=10   --yield=id    --lists=4    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=4  --iterations=20   --yield=id    --lists=4    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=4  --iterations=40   --yield=id    --lists=4    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=4  --iterations=80   --yield=id    --lists=4    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=8  --iterations=10   --yield=id    --lists=4    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=8  --iterations=20   --yield=id    --lists=4    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=8  --iterations=40   --yield=id    --lists=4    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=8  --iterations=80   --yield=id    --lists=4    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=12  --iterations=10   --yield=id    --lists=4    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=12  --iterations=20   --yield=id    --lists=4    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=12  --iterations=40   --yield=id    --lists=4    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=12  --iterations=80   --yield=id    --lists=4    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=16  --iterations=10   --yield=id    --lists=4    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=16  --iterations=20   --yield=id    --lists=4    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=16  --iterations=40   --yield=id    --lists=4    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=16  --iterations=80   --yield=id    --lists=4    --sync=s	      >> lab2b_list.csv

	./lab2_list --threads=1  --iterations=10   --yield=id    --lists=4    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=1  --iterations=20   --yield=id    --lists=4    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=1  --iterations=40   --yield=id    --lists=4    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=1  --iterations=80   --yield=id    --lists=4    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=4  --iterations=10   --yield=id    --lists=4    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=4  --iterations=20   --yield=id    --lists=4    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=4  --iterations=40   --yield=id    --lists=4    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=4  --iterations=80   --yield=id    --lists=4    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=8  --iterations=10   --yield=id    --lists=4    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=8  --iterations=20   --yield=id    --lists=4    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=8  --iterations=40   --yield=id    --lists=4    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=8  --iterations=80   --yield=id    --lists=4    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=12  --iterations=10   --yield=id    --lists=4    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=12  --iterations=20   --yield=id    --lists=4    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=12  --iterations=40   --yield=id    --lists=4    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=12  --iterations=80   --yield=id    --lists=4    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=16  --iterations=10   --yield=id    --lists=4    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=16  --iterations=20   --yield=id    --lists=4    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=16  --iterations=40   --yield=id    --lists=4    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=16  --iterations=80   --yield=id    --lists=4    --sync=m	      >> lab2b_list.csv

	./lab2_list --threads=1  --iterations=1000    --lists=4    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=1  --iterations=1000    --lists=8    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=1  --iterations=1000    --lists=16   --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=2  --iterations=1000    --lists=4    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=2  --iterations=1000    --lists=8    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=2  --iterations=1000    --lists=16   --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=4  --iterations=1000    --lists=4    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=4  --iterations=1000    --lists=8    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=4  --iterations=1000    --lists=16   --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=8  --iterations=1000    --lists=4    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=8  --iterations=1000    --lists=8    --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=8  --iterations=1000    --lists=16   --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=12  --iterations=1000    --lists=4   --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=12  --iterations=1000    --lists=8   --sync=m	      >> lab2b_list.csv
	./lab2_list --threads=12  --iterations=1000    --lists=16  --sync=m	      >> lab2b_list.csv

	./lab2_list --threads=1  --iterations=1000    --lists=4    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=1  --iterations=1000    --lists=8    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=1  --iterations=1000    --lists=16   --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=2  --iterations=1000    --lists=4    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=2  --iterations=1000    --lists=8    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=2  --iterations=1000    --lists=16   --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=4  --iterations=1000    --lists=4    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=4  --iterations=1000    --lists=8    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=4  --iterations=1000    --lists=16   --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=8  --iterations=1000    --lists=4    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=8  --iterations=1000    --lists=8    --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=8  --iterations=1000    --lists=16   --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=12  --iterations=1000    --lists=4   --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=12  --iterations=1000    --lists=8   --sync=s	      >> lab2b_list.csv
	./lab2_list --threads=12  --iterations=1000    --lists=16  --sync=s	      >> lab2b_list.csv
