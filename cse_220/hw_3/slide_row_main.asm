.data
.align 2
row: .word 0
direction: .word -1
board:
.byte 5
.byte 7
.half 1 6 0 3 3 48 6 2 12 12 0 6 3 6 0 3 3 12 0 24 24 1 3 2 6 1 48 12 6 12 1 2 3 48 24 

.text
.globl main
main:
la $a0, board
lw $a1, row
lw $a2, direction
jal slide_row

# Write your own code to print the return value and the contents of the board.

li $v0, 10
syscall

.include "proj3.asm"