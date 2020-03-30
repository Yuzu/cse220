.data
filename: .asciiz "board1.txt"
.align 2
board: .space 2000  # WARNING: During grading, this buffer will be the
                    # smallest possible size to accommodate
                    # the needs of the GameBoard data structure.

.text
.globl main
main:
la $a0, board
la $a1, filename
jal load_game_file

li $v0, 10
syscall

.include "proj3.asm"
