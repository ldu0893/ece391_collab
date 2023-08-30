
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

mystery_asm:
  pushl %ebp          # push ebp to stack space 0
  movl %esp, %ebp     # ebp <- esp, pointing at the next available stack space (space 1)
  PUSHL %EBX          # space 1
  PUSHL %ESI          # space 2
  PUSHL %EDI          # space 3

  MOVL 12(%EBP), %EBX # EBX <- M[%EBP + 12] (space -2)
  CMPL $24, %EBX      # flags <- (EBX-24)
  JA DONE1            # jmp if greater than
  MOVL 8(%EBP), %EBX  # EBX <- M[EBP + 8] (space -1)
  CMPL $42, %EBX      # flags <- (EBX-42)
  JAE DONE1
  MOVL $0, %EDI       # EDI <- 0
  MOVL $1, %ESI       # ESI <- 1

LOOP1:
  CMPL %ESI, %EBX     # EBX - ESI
  JL DONE2            # signed less than
  ADDL %ESI, %EDI     # EDI <- EDI + ESI (EDI is the EBXth triangular number)
  INCL %ESI           # ESI <- ESI + 1
  JMP LOOP1           # loop

DONE2:
  MOVL 12(%EBP), %EBX # EBX <- M[EBP + 12]
  MOVL $1, %EDX       # EDX <- 1
  MOVL $1, %ESI       # ESI <- 1

LOOP2:
  CMPL %ESI, %EBX     # EBX - ESI
  JL DONE3            # signed less than
  IMULL %ESI, %EDX    # EDX <- EDX * ESI (EDX <- EBX factorial)
  INCL %ESI           # ESI <- ESI + 1
  JMP LOOP2           # loop

DONE3:
  ORL %EDI, %EDX      # EDX <- EDX OR EDI (factorial OR triangular num)
  MOVL %EDX, %EAX     # EAX <- EDX
  JMP DONE
  
DONE1:
  MOVL $0, %EAX       # EAX <- 0

DONE:
  POPL %EDI 
  POPL %ESI
  POPL %EBX
  leave
  ret
