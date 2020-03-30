.data
.align 2
board:
.byte 4
.byte 5
.half 1 2 3 12 0 24 96 49152 2 1 192 192 384 0 0 3 3 6 12 12  

.text
.globl main
main:
la $a0, board
jal game_status

# Write your own code to print the return values.

li $v0, 10
syscall

.include "proj3.asm"
