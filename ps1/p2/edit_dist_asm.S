/*
 * tab:2
 *
 * edit_dist_asm.S - inplementation of computing edit distance between two (linked) lists
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice and the following
 * two paragraphs appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE AUTHOR OR THE UNIVERSITY OF ILLINOIS BE LIABLE TO
 * ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL
 * DAMAGES ARISING OUT  OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION,
 * EVEN IF THE AUTHOR AND/OR THE UNIVERSITY OF ILLINOIS HAS BEEN ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE AUTHOR AND THE UNIVERSITY OF ILLINOIS SPECIFICALLY DISCLAIM ANY
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND NEITHER THE AUTHOR NOR
 * THE UNIVERSITY OF ILLINOIS HAS ANY OBLIGATION TO PROVIDE MAINTENANCE,
 * SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Author:        Xiang Li
 * Version:       1
 * Creation Date: Sat Aug 20 2022
 * History:
 *    XL    1    Sat Aug 20 2022
 *        First written.
 */

.data
  UNUSED  = 0
  VAL   = 4
  NEXT = 8

.text
.global edit_dist_asm

# Edit Dist ASM (Assembly)
# Declaration is in edit_dist.h
#
# Registers:
#   EAX - Return Value
#   EBX - root1
#   ESI - root2
#   you may choose how to store your local/temp variables
#

edit_dist_asm:
  pushl %ebp
  movl %esp, %ebp

  # --- STUDENT CODE STARTS HERE ---

  # here's what the stack looks like (top to bottom): Do we want to push Callee FP, Return Address and Return Value?
  # replace <- stack ptr ESP
  # delete
  # insert
  # EDX
  # ECX
  # EDI
  # ESI
  # EBX
  # old EDB <- frame ptr EBP
  # return addr
  # root1
  # root2

  PUSHL %EBX              # push root1 (parameter)
  PUSHL %ESI              # push root2 (parameter)
  PUSHL %EDI
  PUSHL %ECX              # push register ECX (used for )
  PUSHL %EDX              # push register EDX (used for computations)
  
  # PUSHL $0                # push RV

  # push CFP, RA, RV?
  PUSHL $0                # insert
  PUSHL $0                # delete
  PUSHL $0                # replace

  MOVL  8(%EBP), %EBX     # EBX <- *root1
  MOVL  12(%EBP), %ESI    # ESI <- *root2 

  MOVL  %EBX, %ECX        # ECX <- *root1
  ORL   %ESI, %ECX        # ECX <- *root1 OR *root2

  # MOST OF THESE ROOT1 AND ROOT2 ARE *ROOT1 AND *ROOT2 FIX IT LATER
  CMPL  $0, %ECX          # (root1 && root2 == 0)?  (to set flags)
  JE    DONE0             # if root1 (bitwise OR) root2 = 0 (NUll), go to done0 (done0 = return 0)
  CMPL  $0, %EBX          # does root1 == 0? (to set flags)
  JE    DONE1             # if root1 = NULL, done1                   (done1 = return 1 + edit_dist_c(root1,root2->next))
  CMPL  $0, %ESI          # does root2 == 0? (perform comparison)
  JE    DONE2             # if root2 = NULL, done2                   (done2 = return 1 + (edit_dist_c(root1->next,root2)))

  MOVL  4(%EBX), %ECX     # ECX <- root1->val
  MOVL  4(%ESI), %EDX     # EDX <- root2->val
  CMPL  %ECX, %EDX        # (root1->val == root2->val) ?? 
  JE    DONE3             # if root1->val = root2->val, done3        (done3 = return (edit_dist_c(root1->next,root2->next)))


  #$#$#$#$#$#$#$#$#$#$#$#$#$   The next section of code sets the insert, delete, and replace to edit_dist_c() #$#$#$#$#$#$#$#$#$#$#$#$#$

  MOVL  8(%EBX), %ECX     # ECX <- M[EBX+8] (ECX = root1->next)
  PUSHL %ESI              # push root2
  PUSHL %ECX              # push root1->next
  CALL  edit_dist_asm     # Go to function (insert = edit_dist_c(root1->next, root2))
  MOVL  %EAX, 8(%ESP)     # insert = edit_dist_c(root1->next, root2)

  MOVL  8(%ESI), %ECX     # ECX <- M[ESI+8] (ECX = root2->next)
  PUSHL %ECX              # push root2->next
  PUSHL %EBX              # push root1
  CALL  edit_dist_asm     # go to function (delete = edit_dist_c(root1, root2->next))
  MOVL  %EAX, 4(%ESP)     # delete <- edit_dist_c(root1, root2->next)

  MOVL  8(%EBX), %ECX     # ECX = root1->next
  MOVL  8(%ESI), %EDX     # EDX = root2->next
  PUSHL %EDX              # push root2->next
  PUSHL %ECX              # push root1->next
  CALL  edit_dist_asm     # go to function (delete = edit_dist_c(root1))
  MOVL  %EAX, (%ESP)      # replace <- edit_dist_c(root1->next, root2->next)

  ##$#$#$#$#$#$#$#$#$#$#$#$#$ The next section of code is the if statements for the insert, delete, replace #$#$#$#$#$#$#$#$#$#$##$#$#$#$$3

  MOVL  8(%ESP), %ECX     # ECX points to insert now
  CMPL  4(%ESP), %ECX     # insert - delete
  JA    AFTER0            # if insert > delete, false ( we go on and don't return)
  CMPL  (%ESP), %ECX      # insert - replace
  JA    AFTER0            # if insert > replace, false ( we go on and don't return)
  MOVL  8(%ESP), %EAX     # EAX <- insert
  INCL  %EAX              # EAX <- EAX + 1
  JMP   RETURN0           # return (1 + insert)

AFTER0:
  MOVL  4(%ESP), %ECX     # ECX points to delete now
  CMPL  (%ESP), %ECX      # delete - replace
  JA    AFTER1            # if delete > replace, then we go on and don't return
  MOVL  4(%ESP), %EAX     # return value contains delete
  INCL  %EAX              # Then increment, so return register has delete + 1
  JMP   RETURN0           # return (1 + delete) Larry make sure that EAX has the value of delete... I can't tell at first glance

AFTER1:
  MOVL  (%ESP), %EAX      # Return value gets replace
  INCL  %EAX              # Then incremented by one so that it is 1 + replace
  JMP   RETURN0           # Then we are done, and proceed to stack teardown

DONE0: # (done0 = return 0)
  XORL  %EAX, %EAX        # EAX <- 0
  JMP   RETURN0           # Go to return0

DONE1:                    # (done1 = return 1 + edit_dist_c(root1,root2->next))
  MOVL  8(%ESI), %ECX     # ECX <- M[ESI + 8] (ECX = root2->next)
  PUSHL %ECX              # push root2->next
  PUSHL %EBX              # push root1
  CALL  edit_dist_asm     # call function again
  INCL  %EAX              # increment return value by 1
  JMP   RETURN0           # go to return 0

DONE2:                    # (done2 = return 1 + (edit_dist_c(root1->next,root2)))

  MOVL  8(%EBX), %ECX     # ECX <- M[EBX + 8] (ECX = root1->next)
  PUSHL %ESI              # push root2
  PUSHL %ECX              # push root1->next (pushing parameters to stack)
  CALL  edit_dist_asm     # Call the function again
  INCL  %EAX              # Increment return value by 1
  JMP   RETURN0           # go to return 0

DONE3:                    # done3 = return (edit_dist_c(root1->next,root2->next))
  MOVL  8(%EBX), %ECX     # ECX = root1->next
  MOVL  8(%ESI), %EDX     # EDX = root2->next
  PUSHL %EDX              # push root2->next
  PUSHL %ECX              # push root1->next
  CALL  edit_dist_asm     # Call the function again
  MOVL  %EAX, 4(%ESP)     # replace <- edit_dist_asm(root1->next, root2->next)
  JMP   RETURN0           # go to return 0

RETURN0:
  # TEARDOWN0
  ADDL  $12, %ESP         # pop insert, delete, replace
  POPL  %EDX
  POPL  %ECX
  POPL  %EDI
  POPL  %ESI
  POPL  %EBX

  # --- STUDENT CODE ENDS HERE ---

  leave
  ret


