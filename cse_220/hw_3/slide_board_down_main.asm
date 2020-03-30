.data
.align 2
board:
.byte 7
.byte 5
.half 1 2 0 1 6 6 12 3 3 12 0 12 3 2 1 3 0 12 6 2 3 6 0 1 3 48 3 24 48 48 6 6 24 12 24  

.text
.globl main
main:
la $a0, board
jal slide_board_down

# Write your own code to print the return value and the contents of the board.

li $v0, 10
syscall

.include "proj3.asm"