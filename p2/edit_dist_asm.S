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

  # which part goes first? check 220
  PUSHL %ECX
  PUSHL %EDX

  PUSHL $0                # insert
  PUSHL $0                # delete
  PUSHL $0                # replace

  MOVL  %EBX, %ECX        # ECX <- root1
  MOVL  %ESI, %EDX        # EDX <- root2
  ORL   %EDX, %ECX        # ECX <- ECX OR EDX
  CMPL  $0, %ECX          # ECX - 0
  JE    DONE0

  CMPL  $0, %EBX          # EBX - 0
  JE    DONE1

  CMPL $0, %ESI           # ESI - 0
  JE    DONE2

  MOVL  4(%EBX), %ECX
  MOVL  4(%ESI), %EDX
  CMPL  %ECX, %EDX
  JE    DONE3

  # as of now, ESP points to replace - 4
  # delete = ESP + 8
  # insert = ESP + 12
  # PUSH STUFF
  # LEAL  8(%EBX), %EBX     # EBX <- M[EBX + 8] (EBX = root1->next)
  # CALL  edit_dist_asm
  MOVL  %EAX, 12(%ESP)      # insert <- edit_dist_asm(root1->next, root2)

  # PUSHL %EBX
  # PUSHL %ESI
  # PUSH SOMETHING
  # LEAL  8(%ESI), %ESI     # ESI <- M[ESI + 8] (ESI = root2->next)
  # CALL  edit_dist_asm
  MOVL  %EAX, 8(%ESP)       # delete <- edit_dist_asm(root1, root2->next)

  #PUSH STUFF
  #CALL STUFF   -----> copy DONE3
  MOVL  %EAX, 4(%ESP)       # replace <- edit_dist_asm(root1->next, root2->next)

  




DONE0:
  XORL  %EAX, %EAX        # EAX <- 0
  JMP   RETURN0

DONE1:
  # PUSHL %EBX
  # PUSHL %ESI
  # PUSH SOMETHING

  # LEAL  8(%ESI), %ESI     # ESI <- M[ESI + 8] (ESI = root2->next)
  # CALL  edit_dist_asm
  INCL  %EAX
  JMP   RETURN0

DONE2:
  #PUSH STUFF

  # LEAL  8(%EBX), %EBX     # EBX <- M[EBX + 8] (EBX = root1->next)
  # CALL  edit_dist_asm
  INCL  %EAX
  JMP   RETURN0

DONE3:
  #PUSH STUFF

  #CALL STUFF
  JMP   RETURN0

RETURN0:
  # TEARDOWN0
  # --- STUDENT CODE ENDS HERE ---

  leave
  ret

