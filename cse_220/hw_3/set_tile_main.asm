.data
.align 2
row: .word 3
col: .word 1
value: .word 96000
board:
.byte 8
.byte 7
.half 6 1 6 2 3 3 6 0 1 2 0 0 0 0 0 2 0 1 2 3 6 6 48 12 1 24 3 3 2 12 3 0 1 3 0 3 6 3 6 3 6 3 12 12 12 12 12 12 12 24 3 2 6 1 0 3 
newline: .asciiz "\n"
space: .asciiz " "

.text
.globl main
main:
la $a0, board
lw $a1, row
lw $a2, col
lw $a3, value
li $s0 -420
li $s1 -420
li $s2 -420
li $s3 -420
li $s4 -420
li $s5 -420
li $s6 -420
li $s7 -420
jal set_tile

move $a0, $v0
li $v0, 1
syscall

li $v0, 4
	la $a0, newline
	syscall
	
# Write your own code to print the return value and the contents of the board.

la $t0, board
li $t1, 8 # number of rows
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

li $v0, 10
syscall

.include "proj3.asm"
