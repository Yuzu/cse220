.data
card: .word 5458500

.text
.globl main
main:
lw $a0, card
jal card_points

# Write your own code here to verify that the function is correct.

move $t0, $v0

li $v0, 1
move $a0, $t0
syscall

li $v0, 10
syscall

.include "proj5.asm"
