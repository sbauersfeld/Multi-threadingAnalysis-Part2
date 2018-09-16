
#include "SortedList.h"
#include <sched.h>
#include <stdio.h>
#include <string.h>

void SortedList_insert(SortedList_t *list, SortedListElement_t *element){
  if (list == NULL || element == NULL)
    return;

  SortedListElement_t *list2 = list->next;
  while (list2->next != list) {
    if (strcmp(element->key, list2->key) <= 0){
	break;
      }
      list2 = list2->next;
  }
  if(opt_yield & INSERT_YIELD){
      sched_yield();
      //      fprintf(stdout, "insert yield");
  }
    list2->next->prev = element;
    element->next = list2->next;
    element->prev = list2;
    list2->next = element;
}

int SortedList_delete( SortedListElement_t *element) {
  if (element == NULL || element->next->prev != element || element->prev->next != element)
    return 1;
  if(opt_yield & DELETE_YIELD){
    sched_yield();
    //    fprintf(stdout, "delete yield");
  }
  element->next->prev = element->prev;
  element->prev->next = element->next;
  return 0;
}

SortedListElement_t *SortedList_lookup(SortedList_t *list, const char *key){
  if(list == NULL || key == NULL){
    return NULL;
  }
  SortedListElement_t *list2 = list->next;
  while(list2 != list){
    if(strcmp(key, list2->key) == 0){
      return list2;
    }
    if(opt_yield & LOOKUP_YIELD){
      sched_yield();
      //      fprintf(stdout, "lookup yield");
    }
    list2 = list2->next;
  }
  return NULL;
}

int SortedList_length(SortedList_t *list){
  if (list == NULL)
    return -1;
  SortedListElement_t *list2 = list;
  int i = 0;
  while (list2->next != NULL && list2->next != list){
    if (list2->prev->next != list2 || list2->next->prev != list2){
      return -1;
    }
    if(opt_yield & LOOKUP_YIELD){
      sched_yield();
      //      fprintf(stdout, "length yield");
    }
    list2 = list2->next;
    i+=1;
  }
  if (list2->next == NULL){
    return -1;
  }
  else {
    return i;
  }
}
