.data
filename1: .asciiz "board1.txt"
filename2: .asciiz "output.txt"
.align 2
board: .space 2000  # WARNING: During grading, this buffer will be the
                    # smallest possible size to accommodate
                    # the needs of the GameBoard data structure.

.text
.globl main
main:
la $a0, board
la $a1, filename1
jal load_game_file

la $a0, board
la $a1, filename2
li $s0 -420
li $s1 -420
li $s2 -420
li $s3 -420
li $s4 -420
li $s5 -420
li $s6 -420
li $s7 -420
jal save_game_file

li $v0, 10
syscall

.include "proj3.asm"
