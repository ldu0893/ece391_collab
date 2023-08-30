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

  # here's what the stack looks like (top to bottom):
  # replace <- stack ptr ESP
  # delete
  # insert
  # EDX
  # ECX
  # ESI
  # EBX
  # root1
  # root2 <- frame ptr EBP
  PUSHL %EBX
  PUSHL %ESI  
  PUSHL %ECX
  PUSHL %EDX
  PUSHL $0                # insert
  PUSHL $0                # delete
  PUSHL $0                # replace

  LEAL  -4(%EBP), %EBX    # EBX <- root1
  LEAL  (%EBP), %ESI      # ESI <- root2 ---> is this step necessary?? need to know what the stack looks like b4

  MOVL  %EBX, %ECX        # ECX <- root1
  ORL   %ESI, %ECX        # ECX <- root1 OR root2
  CMPL  $0, %ECX
  JE    DONE0             # if root1 OR root2 = NUll, done0
  CMPL  $0, %EBX
  JE    DONE1             # if root1 = NULL, done1
  CMPL  $0, %ESI
  JE    DONE2             # if root2 = NULL, done2

  MOVL  4(%EBX), %ECX
  MOVL  4(%ESI), %EDX
  CMPL  %ECX, %EDX
  JE    DONE3             # if root1->val = root2->val, done3

  LEAL  8(%EBX), %ECX     # ECX <- M[EBX + 8] (ECX = root1->next)
  PUSHL %ESI              # push root2
  PUSHL %ECX              # push root1->next
  CALL  edit_dist_asm
  MOVL  %EAX, 8(%ESP)    # insert <- edit_dist_asm(root1->next, root2)

  LEAL  8(%ESI), %ECX     # ECX <- M[ESI + 8] (ECX = root2->next)
  PUSHL %ECX              # push root2->next
  PUSHL %EBX              # push root1
  CALL  edit_dist_asm
  MOVL  %EAX, 4(%ESP)     # delete <- edit_dist_asm(root1, root2->next)

  LEAL  8(%EBX), %ECX     # ECX = root1->next
  LEAL  8(%ESI), %EDX     # EDX = root2->next
  PUSHL %EDX              # push root2->next
  PUSHL %ECX              # push root1->next
  CALL  edit_dist_asm
  MOVL  %EAX, (%ESP)      # replace <- edit_dist_asm(root1->next, root2->next)

  LEAL  8(%ESP), %ECX
  CMPL  4(%ESP), %ECX     # insert - delete
  JA    AFTER0            # if insert > delete, false
  CMPL  (%ESP), %ECX      # insert - replace
  JA    AFTER0            # if insert > replace, false
  MOVL  8(%ESP), %EAX     # EAX <- insert
  INCL  %EAX              # EAX <- EAX + 1
  JMP   RETURN0

AFTER0:
  LEAL  4(%ESP), %ECX
  CMPL  (%ESP), %ECX      # delete - replace
  JA    AFTER1
  MOVL  4(%ESP), %EAX
  INCL  %EAX
  JMP   RETURN0

AFTER1:
  MOVL  (%ESP), %EAX
  INCL  %EAX
  JMP   RETURN0

DONE0:
  XORL  %EAX, %EAX        # EAX <- 0
  JMP   RETURN0

DONE1:
  LEAL  8(%ESI), %ECX     # ECX <- M[ESI + 8] (ECX = root2->next)
  PUSHL %ECX              # push root2->next
  PUSHL %EBX              # push root1
  CALL  edit_dist_asm
  INCL  %EAX
  JMP   RETURN0

DONE2:
  LEAL  8(%EBX), %ECX     # ECX <- M[EBX + 8] (ECX = root1->next)
  PUSHL %ESI              # push root2
  PUSHL %ECX              # push root1->next
  CALL  edit_dist_asm
  INCL  %EAX
  JMP   RETURN0

DONE3:
  LEAL  8(%EBX), %ECX     # ECX = root1->next
  LEAL  8(%ESI), %EDX     # EDX = root2->next
  PUSHL %EDX              # push root2->next
  PUSHL %ECX              # push root1->next
  CALL  edit_dist_asm
  MOVL  %EAX, 4(%ESP)     # replace <- edit_dist_asm(root1->next, root2->next)
  JMP   RETURN0

RETURN0:
  # TEARDOWN0
  ADDL  $
  # --- STUDENT CODE ENDS HERE ---

  leave
  ret

