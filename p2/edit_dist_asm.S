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

/*
 * Edit Dist ASM (Assembly)
 * Declaration is in edit_dist.h
 *
 * Registers:
 *   EAX - Return Value
 *   EBX - root1
 *   ESI - root2
 *   you may choose how to store your local/temp variables
 *
 *   Parameters:
 *   8(%ebp) : root1
 *   12(%ebp) : root2
*/

.data
  UNUSED  = 0
  VAL   = 4
  NEXT = 8

.text
.global edit_dist_asm

edit_dist_asm:
  # Callee Setup
  pushl %ebp
  movl %esp, %ebp

  # Save Registers
  pushl %ebx      # Register for Root1
  pushl %esi      # Register for Root2
  pushl %edi      # Temporary 

  # Load Parameters
  movl 8(%ebp), %ebx
  movl 12(%ebp), %esi

  /* Allocate Space for Local Variables
    -4(%ebp) : insert
    -8(%ebp) : delete
    -12(%ebp) : replace
  */
  subl $12, %esp

  # root1 == NULL && root2 == NULL
ROOTS_CMP_NULL:
  cmpl %ebx, NULL
  jne ROOT1_CMP_NULL      # Continue
  cmpl %esi, NULL
  jne ROOT1_CMP_NULL      # Continue
  jmp RET0                # return 0

# root1 == NULL
ROOT1_CMP_NULL:
  cmpl %ebx, NULL
  jne ROOT2_CMP_NULL      # Continue
  jmp RET1_R1_R2NEXT      # return 1 + edit_dist_asm(root1, root2->next)

# root2 == NULL
ROOT2_CMP_NULL:
  cmpl %esi, NULL
  jne ROOT_VAL_CMP        # Continue
  jmp RET1_R1NEXT_R2      # return 1 + edit_dist_asm(root1->next, root2) 

ROOT_VAL_CMP:
  nop
  nop

  # ====================== Returns ======================
RET0:
  movl $0, %eax        # Return Zero
  jmp DONE
RET1_R1_R2NEXT:
  # Caller Setup
  # Save Registers
  # Parameters
  call edit_dist_asm
  incl %eax             # +1
  jmp DONE
RET1_R1NEXT_R2:
  # Caller Setup
  jmp DONE
  # ====================== Returns ======================

DONE: 
  # Restore Registers
  popl %edi
  popl %esi
  popl %ebx

  # Callee Teardown
  leave
  ret

NULL: .long 0
