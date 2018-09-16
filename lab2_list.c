
#include "SortedList.h"
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <time.h>
#include <unistd.h>
#include <getopt.h>
#include <signal.h>
#include <errno.h>
#include <string.h>

//race conditions may result in segementation faults, this function logs them
void signal_handler(int signo){
  if (signo == SIGSEGV){
    fprintf(stderr,"Received segmentation fault. Error message is: %s\n", strerror(errno));
    exit(2);
  }
}

//global variables shared by all threads
int *flag;
int iterations = 1;
SortedListElement_t *array;
int opt_yield = 0;
char sync_type = 'a';
SortedList_t* head;
pthread_mutex_t* lock;
int capacity;
int list_num = 1;
long long *timedlock;

//the function run by each thread
void* threader(void* arg){
  //each thread is passed an integer id
  int* s = (int*) arg;
  int start = *s;
  int id = start;
  
  //begin processing the element array at a location determined by thread id 
  start = start * iterations;
  int end = start + iterations;
  int i = 0;
  struct timespec lockstart, lockend;

  //insert all elements into a single list
  for (i = start; i < end; i++){
    int bucket = abs((int) *array[i].key) % list_num; //hash key to determine which list to work with
    if (sync_type == 'm'){
      if(clock_gettime(CLOCK_MONOTONIC, &lockstart) == -1){ //time to get each mutex lock per thread
	fprintf(stderr, "Error: clock_gettime failed with message: %s", strerror(errno));
	exit(2);
      }
      pthread_mutex_lock(&lock[bucket]);
      if(clock_gettime(CLOCK_MONOTONIC, &lockend) == -1){
	fprintf(stderr, "Error: clock_gettime failed with message: %s", strerror(errno));
	exit(2);
      }
      timedlock[id] += 1000000000 * (lockend.tv_sec - lockstart.tv_sec) + lockend.tv_nsec - lockstart.tv_nsec; //add up total time per thread
    }
    else if (sync_type == 's'){
      if (clock_gettime(CLOCK_MONOTONIC, &lockstart) == -1){ //time to get each spin lock per thread
	fprintf(stderr, "Error: clock_gettime failed with message: %s", strerror(errno));
	exit(2);
      }
      while(__sync_lock_test_and_set(&flag[bucket], 1));
      if (clock_gettime(CLOCK_MONOTONIC, &lockend) == -1){
	fprintf(stderr, "Error: clock_gettime failed with message: %s", strerror(errno));
	exit(2);
      }
      timedlock[id] += 1000000000 * (lockend.tv_sec - lockstart.tv_sec) + lockend.tv_nsec - lockstart.tv_nsec;
    }
    
    SortedList_insert(&head[bucket], &array[i]);

    if (sync_type == 'm'){
      pthread_mutex_unlock(&lock[bucket]);
    }
    else if (sync_type == 's'){
      __sync_lock_release(&flag[bucket]);
    }
  }

  //this section finds the length of the list
  int total_length = 0;
  int list_length[list_num];
  for (i = 0; i < list_num; i++){
    if (sync_type == 'm'){
      if (clock_gettime(CLOCK_MONOTONIC, &lockstart) == -1){
	fprintf(stderr, "Error: clock_gettime failed with message: %s", strerror(errno));
	exit(2);
      }
      pthread_mutex_lock(&lock[i]);
      if (clock_gettime(CLOCK_MONOTONIC, &lockend) == -1){
	fprintf(stderr, "Error: clock_gettime failed with message: %s", strerror(errno));
	exit(2);
      }
      timedlock[id] += 1000000000 * (lockend.tv_sec - lockstart.tv_sec) + lockend.tv_nsec - lockstart.tv_nsec;
    }
    else if (sync_type == 's'){
      if (clock_gettime(CLOCK_MONOTONIC, &lockstart) == -1){
	fprintf(stderr, "Error: clock_gettime failed with message: %s", strerror(errno));
	exit(2);
      }
      while(__sync_lock_test_and_set(&flag[i], 1));
      if (clock_gettime(CLOCK_MONOTONIC, &lockend) == -1){
	fprintf(stderr, "Error: clock_gettime failed with message: %s", strerror(errno));
	exit(2);
      }
      timedlock[id] += 1000000000 * (lockend.tv_sec - lockstart.tv_sec) + lockend.tv_nsec - lockstart.tv_nsec;
    }
  
    list_length[i] = SortedList_length(&head[i]);

    if (sync_type == 'm'){
      pthread_mutex_unlock(&lock[i]);
    }
    else if (sync_type == 's'){
      __sync_lock_release(&flag[i]);
    }

    //log an error if the list is malformed
    if (list_length[i] == -1){
      fprintf(stderr, "Error finding length of list.");
      exit(2);
    }
    total_length+=list_length[i];
  }
  
  //this section looks up each key and deletes it
  SortedListElement_t *ptr = NULL;
  for (i = start; i < end; i++){
    int bucket = abs((int) *array[i].key) % list_num;
    if (sync_type == 'm'){
      if (clock_gettime(CLOCK_MONOTONIC, &lockstart) == -1){
	fprintf(stderr, "Error: clock_gettime failed with message: %s", strerror(errno));
	exit(2);
      }
      pthread_mutex_lock(&lock[bucket]);
      if (clock_gettime(CLOCK_MONOTONIC, &lockend) == -1){
	fprintf(stderr, "Error: clock_gettime failed with message: %s", strerror(errno));
	exit(2);
      }
      timedlock[id] += 1000000000 * (lockend.tv_sec - lockstart.tv_sec) + lockend.tv_nsec - lockstart.tv_nsec;
    }
    else if (sync_type == 's'){
      if (clock_gettime(CLOCK_MONOTONIC, &lockstart) == -1){
	fprintf(stderr, "Error: clock_gettime failed with message: %s", strerror(errno));
	exit(2);
      }
      while(__sync_lock_test_and_set(&flag[bucket], 1));
      if (clock_gettime(CLOCK_MONOTONIC, &lockend) == -1){
	fprintf(stderr, "Error: clock_gettime failed with message: %s", strerror(errno));
	exit(2);
      }
      timedlock[id] += 1000000000 * (lockend.tv_sec - lockstart.tv_sec) + lockend.tv_nsec - lockstart.tv_nsec;
    }
    if((ptr = SortedList_lookup(&head[bucket], array[i].key)) == NULL){
      fprintf(stderr, "Error looking up item in the list.");
      exit(2);
    }
    if(SortedList_delete(ptr) == 1){
      fprintf(stderr, "Error deleting item in the list.");
      exit(2);
    }
    if (sync_type == 'm'){
      pthread_mutex_unlock(&lock[bucket]);
    }
    else if (sync_type == 's'){
      __sync_lock_release(&flag[bucket]);
    }
  }
  return NULL;
}

int main(int argc, char** argv){
  int thread_num = 1;
  char* yops = "none";
  struct option opts[] = {
    {"threads", required_argument, NULL, 't'},
    {"iterations", required_argument, NULL, 'i'},
    {"yield", required_argument, NULL, 'y'},
    {"sync", required_argument, NULL, 's'},
    {"lists", required_argument, NULL, 'l'},
    {0, 0, 0, 0}
  };
  int a = 0;
  char optresult;
  int length;
  int iopt = 0;
  int dopt = 0;
  int lopt = 0;

  //parses the options
  while ((optresult = getopt_long(argc, argv, "", opts, NULL)) != -1){
    switch (optresult){
    case 'l':
      list_num = atoi(optarg);
      break;
    case 's':
      sync_type = optarg[0];
      if ((sync_type != 's' && sync_type != 'm') || strlen(optarg) > 1) {
	fprintf(stderr, "Correct usage is ./lab2_list [--threads=<number>] [--iterations=<number>] [--sync=<sm>] [--yield=<idl>]\n");
	exit(1);
      }
      break;
    case 'y':
      length = strlen(optarg);
      for (a = 0; a < length; a++){
	if (optarg[a] == 'i'){
	  opt_yield |= 0x1;
	  iopt = 1;
	}
	else if (optarg[a] == 'd'){
	  opt_yield |= 0x2;
	  dopt = 1;
	}
	else if (optarg[a] == 'l'){
	  opt_yield |= 0x4;
	  lopt = 1;
	}
	else {
	  fprintf(stderr, "Correct usage is ./lab2_list [--threads=<number>] [--iterations=<number>] [--sync=<sm>] [--yield=<idl>]\n");
	  exit(1);
	}
      }
      break;
    case 't':
      thread_num = atoi(optarg);
      break;
    case 'i':
      iterations = atoi(optarg);
      break;
    case 0:
      break;
    case '?':
    default:
      fprintf(stderr, "Correct usage is ./lab2_add [--threads=<number>] [--iterations=<number>] [--sync=<sm>] [--yield=<idl>]\n");
      exit(1);
    }
  }

  //changes string yops so that if reflects the specified options
  if (iopt && dopt && lopt){
    yops = "idl";
  }
  else if(iopt && dopt){
    yops = "id";
  }
  else if(iopt && lopt){
    yops = "il";
  }
  else if(lopt && dopt){
    yops = "dl";
  }
  else if(iopt){
    yops = "i";
  }
  else if(dopt){
    yops = "d";
  }
  else if(lopt){
    yops = "l";
  }

  //allocates data to hold the element array
  if (sync_type == 'm'){
    int i = 0;
    lock = (pthread_mutex_t*) malloc(list_num*sizeof(pthread_mutex_t));
    if (lock == NULL){
      fprintf(stderr, "Error: malloc failed\n");
      exit(2);
    }
    for (i=0; i < list_num; i++){
      pthread_mutex_init(&lock[i], NULL);
    }
  }
  else if(sync_type == 's'){
    flag = (int*) malloc(list_num*sizeof(int));
    if (flag == NULL){
      fprintf(stderr, "Error: malloc failed\n");
      exit(2);
    }
    int i = 0;
    for (i=0; i < list_num; i++){
      flag[i] = 0;
    }
  }

  //create an integer to hold the time to acquire locks for each thread
  timedlock = (long long*) malloc(thread_num*sizeof(long long));
  int ti = 0;
  for (ti = 0; ti < thread_num; ti++){
    timedlock[ti] = 0;
  }
  
  srand(time(NULL));
  pthread_t threads[thread_num];
  int threadId[thread_num];
  capacity = thread_num * iterations;
  array = (SortedListElement_t*) malloc(sizeof(SortedListElement_t)*capacity);
  if (array == NULL){
    fprintf(stderr, "Error: malloc failed\n");
    exit(2);
  }
  a = 0;

  //creates a random key for each element in the array
  for (a = 0; a < capacity; a++){
      int l = (rand() % 10) + 1;
      char *randkey = (char*) malloc((l+1)*sizeof(char));
      if (randkey == NULL){
	fprintf(stderr, "Error: malloc failed\n");
	exit(2);
      }
      int j = 0;
      for (j = 0; j < l; j++){
	randkey[j] = 33 + (rand() % 90);
      }
      randkey[l] = '\0';
      array[a].key = randkey;
  }
  
  //register signal handler and initialize the head linked list pointer
  signal(SIGSEGV, signal_handler);
  head = (SortedList_t*) malloc(sizeof(SortedList_t)*list_num);
  if (head == NULL){
    fprintf(stderr, "Error: malloc failed\n");
    exit(2);
  }
  //create specified number of lists
  a = 0;
  for (a=0; a < list_num; a++){
    head[a].next = &head[a];
    head[a].prev = &head[a];
  }
  a = 0;
  
  //get the start time
  struct timespec start, end;
  if(clock_gettime(CLOCK_MONOTONIC, &start) == -1){
    fprintf(stderr,"Clock gettime failure. Error message is: %s\n", strerror(errno));
    exit(2);
  }

  //create all the threads
  for (a = 0; a < thread_num; a++){
    threadId[a] = a;
    if (pthread_create(&threads[a], NULL, threader, &threadId[a])){
      fprintf(stderr, "Thread creation failure. Error message is: %s\n", strerror(errno));
      exit(2);
    }
  }

  //wait for all the threads to finish running
  a = 0;
  for (a = 0; a < thread_num; a++){
    if (pthread_join(threads[a], NULL)){
      fprintf(stderr, "Thread join failure. Error message is: %s\n", strerror(errno));
      exit(2);
    }
  }

  //get the finish time
  if(clock_gettime(CLOCK_MONOTONIC, &end) == -1){
    fprintf(stderr,"Clock gettime failure. Error message is: %s\n", strerror(errno));
    exit(2);
  }

  //ensure that the final length is zero
  int list_length[list_num];
  for (a = 0; a < list_num; a++){
    list_length[a] = SortedList_length(&head[a]);
    if(list_length[a] != 0){
      fprintf(stderr, "Error: Final length is not zero.");
      free(array);
      free(head);
      int j = 0;
      if (sync_type == 'm'){
	for (j = 0; j < list_num; j++){
	  pthread_mutex_destroy(&lock[j]);
	}
      }
      exit(2);
    }
  }

  //calculate the running time and time per operation
  int totalop = 3*iterations*thread_num;
  long long time = 1000000000 * (end.tv_sec - start.tv_sec) + end.tv_nsec - start.tv_nsec;
  long long tpo = time/totalop;
  long long waittime = 0;
  for (a = 0; a < thread_num; a++){
    waittime += timedlock[a];
  }
  waittime /= totalop;

  //print results based on the specified options
  switch(sync_type){
  case 'a':
    fprintf(stdout, "list-%s-none,%d,%d,%d,%d,%lld,%lld,%lld\n",yops,thread_num,iterations,list_num,totalop,time,tpo,waittime);
    break;
  case 's':
    fprintf(stdout, "list-%s-s,%d,%d,%d,%d,%lld,%lld,%lld\n",yops,thread_num,iterations,list_num,totalop,time,tpo,waittime);
    break;
  case 'm':
    fprintf(stdout, "list-%s-m,%d,%d,%d,%d,%lld,%lld,%lld\n",yops,thread_num,iterations,list_num,totalop,time,tpo,waittime);
    break;
  }

  //free allocated memory
  free(timedlock);
  free(array);
  free(head);
  int j = 0;
  if (sync_type == 'm'){
    for (j = 0; j < list_num; j++){
      pthread_mutex_destroy(&lock[j]);
    }
  }
  else if (sync_type == 's'){
    free(flag);
  }
  exit(0);
}
