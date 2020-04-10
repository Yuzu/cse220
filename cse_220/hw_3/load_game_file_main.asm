.data
filename: .asciiz "board2.txt"
.align 2
board: .space 2000  # WARNING: During grading, this buffer will be the
                    # smallest possible size to accommodate
                    # the needs of the GameBoard data structure.
newline: .asciiz "\n"
space: .asciiz " "
.text
.globl main
main:
la $a0, board
la $a1, filename
li $s0 -420
li $s1 -420
li $s2 -420
li $s3 -420
li $s4 -420
li $s5 -420
li $s6 -420
li $s7 -420
jal load_game_file

la $t0, board
li $t1, 4 # number of rows
li $t2, 4# number of columns

addi $t0, $t0, 2
li $t3, 0  # i, row counter

row_loop:
	li $t4, 0  # j, column counter
col_loop:
	
	lhu $s0, 0($t0)
	
	li $v0, 1
	move $a0, $s0
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	addi $t0, $t0, 2
	addi $t4, $t4, 1  # j++
	blt $t4, $t2, col_loop
col_loop_done:
	li $v0, 4
	la $a0, newline
	syscall
addi $t3, $t3, 1  # i++
blt $t3, $t1, row_loop

row_loop_done:

li $a0, '\n'
li $v0, 11
syscall
	
# Terminate the program
li $v0, 10
syscall

li $v0, 10
syscall

.include "proj3.asm"
