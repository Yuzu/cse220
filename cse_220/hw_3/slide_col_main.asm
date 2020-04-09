.data
.align 2
col: .word 5
direction: .word 1
board:
.byte 7
.byte 5
.half 1 2 0 1 6 6 12 3 3 12 0 12 3 2 1 3 0 12 6 2 3 6 0 1 3 48 3 24 48 48 6 6 24 12 24 
newline: .asciiz "\n"
space: .asciiz " "

.text
.globl main
main:
la $a0, board
lw $a1, col
lw $a2, direction
jal slide_col
move $s7, $v0
# Write your own code to print the return value and the contents of the board.


la $t0, board
li $t1, 7 # number of rows
li $t2, 5# number of columns

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

li $v0, 4
la $a0, newline
syscall

li $v0, 1
move $a0, $s7
syscall

li $v0, 4
la $a0, newline
syscall

li $v0, 10
syscall

.include "proj3.asm"
