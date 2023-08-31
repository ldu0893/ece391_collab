
/*
 * tab:2
 *
 * mystery_asm.S - Assembly mystery
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
 * Author:        Yan Miao
 * Version:       1
 * Creation Date: Sun Aug 29 2021
 * Author:        Xiang Li
 * Version:       2
 * Modified Date: Sun Aug 21 2022
 * History:
 *    YM    1    Sun Aug 29 2021
 *    XL    2    Sun Aug 21 2022
 */

.data

.text
.global mystery_asm

# mystery (Assembly)

# CODE OUPUT = x! || yth triangular num

mystery_asm:
  # Setup stack
  pushl %ebp            # EBP to stack
  movl %esp, %ebp       # ESP to EBP - base of stack is now top of stack
  PUSHL %EBX            # EBX to stack
  PUSHL %ESI            # Source index to stack
  PUSHL %EDI            # Destination index to stack

  # Checking for inputs out of bounds - will not compute output if x>24 or y>=42 (prevents overflow)
  MOVL 12(%EBP), %EBX   # EBX <- M[EBP + 12] == x
  CMPL $24, %EBX        # EBX - 24
  JA DONE1              # If greater (unsigned comparison), jump to done
  MOVL 8(%EBP), %EBX    # EBX <- M[EBP + 8] == y
  CMPL $42, %EBX        # EBX - 42 
  JAE DONE1             # If greater or equal (unsigned comparison), jump to done
  MOVL $0, %EDI         # If not done, EDI <- 0, ESI <- 1
  MOVL $1, %ESI

# Loop to compute triangular number
LOOP1:                  # while
  CMPL %ESI, %EBX       # EBX - ESI
  JL DONE2              # If EBX < ESI (signed), DONE2
  ADDL %ESI, %EDI       # EDI += ESI
  INCL %ESI             # EDI = 1 + 2 + 3 + 4 .....
  JMP LOOP1

DONE2:
  MOVL 12(%EBP), %EBX   # EBX <- M[EBP + 12] - store y in EBX
  MOVL $1, %EDX         # EDX <- 1
  MOVL $1, %ESI         # ESI <- 1

LOOP2:
  CMPL %ESI, %EBX       # EBX - ESI
  JL DONE3              # If EBX < ESI (signed), DONE3
  IMULL %ESI, %EDX      
  INCL %ESI
  JMP LOOP2

# Store output in EAX
DONE3:
  ORL %EDI, %EDX        # Or the two results
  MOVL %EDX, %EAX       # Move result to EAX
  JMP DONE
  
# If invalid inputs (too large), output = 0
DONE1:
  MOVL $0, %EAX

# Clean stack
DONE:
  POPL %EDI
  POPL %ESI
  POPL %EBX
  leave
  ret