#include "spinlock_ece391.h"
#include "solution.h"
#include <bits/types.h>


ps_lock ps_lock_create(spinlock_t *lock) {
  ps_lock ps;

  ps.lock = lock;
  ps.count_profs = 0;
  ps.count_tas = 0;
  ps.count_students = 0;
  ps.queue_profs = 0;
  ps.queue_tas = 0;
  spinlock_init_ece391(ps.lock);

  return ps;
}

void professor_enter(ps_lock *ps) {
  ps->queue_profs++; // single instruction, atomic

  while (1) {
    // try to acquire the lock
    spinlock_lock_ece391(ps->lock);

    // check if we can enter
    int count_total = ps->count_profs + ps->count_tas + ps->count_students;
    if (
      count_total < 20 &&
      ps->count_tas == 0 &&
      ps->count_students == 0
    ) {
      ps->count_profs++;
      ps->queue_profs--;
      spinlock_unlock_ece391(ps->lock);
      break;
    }

    // release the lock
    spinlock_unlock_ece391(ps->lock);
  }
}

void professor_exit(ps_lock *ps) {
  ps->count_profs--; // single instruction, atomic
}

void ta_enter(ps_lock *ps) {
  ps->queue_tas++; // single instruction, atomic

  while (1) {
    // try to acquire the lock
    spinlock_lock_ece391(ps->lock);

    // check if we can enter
    int count_total = ps->count_profs + ps->count_tas + ps->count_students;
    if (
      count_total < 20 &&
      ps->count_profs == 0 &&
      ps->queue_profs == 0
    ) {
      ps->count_tas++;
      ps->queue_tas--;
      spinlock_unlock_ece391(ps->lock);
      break;
    }

    // release the lock
    spinlock_unlock_ece391(ps->lock);
  }
}

void ta_exit(ps_lock *ps) {
  ps->count_tas--; // single instruction, atomic
}

void student_enter(ps_lock *ps) {
  while (1) {
    // try to acquire the lock
    spinlock_lock_ece391(ps->lock);

    // check if we can enter
    int count_total = ps->count_profs + ps->count_tas + ps->count_students;
    if (
      count_total < 20 &&
      ps->count_profs == 0 &&
      ps->queue_profs == 0 &&
      ps->queue_tas == 0
    ) {
      ps->count_students++;
      spinlock_unlock_ece391(ps->lock);
      break;
    }

    // release the lock
    spinlock_unlock_ece391(ps->lock);
  }
}

void student_exit(ps_lock *ps) {
  ps->count_students--; // single instruction, atomic
}