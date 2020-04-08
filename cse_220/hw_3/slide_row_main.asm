.data
.align 2
row: .word 0
direction: .word -1
board:
.byte 5
.byte 7
.half 1 6 0 3 3 48 6 2 12 12 0 6 3 6 0 3 3 12 0 24 24 1 3 2 6 1 48 12 6 12 1 2 3 48 24 
newline: .asciiz "\n"
space: .asciiz " "

.text
.globl main
main:
la $a0, board
lw $a1, row
lw $a2, direction
jal slide_row
move $s7, $v0
# Write your own code to print the return value and the contents of the board.


la $t0, board
li $t1, 5 # number of rows
li $t2, 7# number of columns

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
