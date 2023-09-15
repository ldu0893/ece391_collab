#include "spinlock_ece391.h"
#include "solution.h"
#include <bits/types.h>


ps_lock ps_lock_create(spinlock_t *lock) {
  spinlock_init_ece391(lock);
}

void professor_enter(ps_lock *ps) {
  // spinlock_lockps->lock  
}

void professor_exit(ps_lock *ps) {
  // Fill this out!!!
}

void ta_enter(ps_lock *ps) {
  // Fill this out!!!
}

void ta_exit(ps_lock *ps) {
  // Fill this out!!!
}

void student_enter(ps_lock *ps) {
  // Fill this out!!!
}

void student_exit(ps_lock *ps) {
  // Fill this out!!!
}