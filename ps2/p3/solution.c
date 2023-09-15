#include "spinlock_ece391.h"
#include "solution.h"
#include <bits/types.h>
#include <stdio.h>


ps_lock ps_lock_create(spinlock_t *lock) {
  printf("create\n");
  ps_lock* ps;
  ps->lock = lock;
  ps->prof_count=0;
  ps->ta_count=0;
  ps->student_count=0;
  ps->tot_count=0;
  ps->prof_queue_count=0;
  ps->ta_queue_count=0;
  printf(ps->prof_count);
  spinlock_init_ece391(lock);
  return *ps;
}

void professor_enter(ps_lock *ps) {
  printf("prof enter\n");
  ps->prof_queue_count++;
  while (1) {
    spinlock_lock_ece391(ps->lock);
    if (ps->tot_count < 20 && ps->student_count == 0 && ps->ta_count == 0) {
      ps->prof_queue_count--;
      ps->prof_count++;
      ps->tot_count++;
      spinlock_unlock_ece391(ps->lock);
      return;
    }
    spinlock_unlock_ece391(ps->lock);
  }
}

void professor_exit(ps_lock *ps) {
    printf("prof exit\n");
  spinlock_lock_ece391(ps->lock);
  ps->prof_count--;
  ps->tot_count--;
  spinlock_unlock_ece391(ps->lock);
}

void ta_enter(ps_lock *ps) {
    printf("ta enter\n");
  ps->ta_queue_count++;
  while (1) {
    spinlock_lock_ece391(ps->lock);
    if (ps->tot_count < 20 && ps->prof_count == 0 && ps->prof_queue_count == 0) {
      ps->ta_queue_count--;
      ps->ta_count++;
      ps->tot_count++;
      spinlock_unlock_ece391(ps->lock);
      return;
    }
    spinlock_unlock_ece391(ps->lock);
  }
}

void ta_exit(ps_lock *ps) {
    printf("ta exit\n");
  spinlock_lock_ece391(ps->lock);
  ps->ta_count--;
  ps->tot_count--;
  spinlock_unlock_ece391(ps->lock);
}

void student_enter(ps_lock *ps) {
    printf("student enter\n");
  while (1) {
    spinlock_lock_ece391(ps->lock);
    if (ps->tot_count < 20 && ps->prof_count == 0 && ps->prof_queue_count == 0 && ps->ta_queue_count == 0) {
      ps->student_count++;
      ps->tot_count++;
      spinlock_unlock_ece391(ps->lock);
      return;
    }
    spinlock_unlock_ece391(ps->lock);
  }
}

void student_exit(ps_lock *ps) {
    printf("student exitf\n");
  spinlock_lock_ece391(ps->lock);
  ps->student_count--;
  ps->tot_count--;
  spinlock_unlock_ece391(ps->lock);
}
