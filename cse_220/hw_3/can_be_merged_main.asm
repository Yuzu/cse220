.data
.align 2
row1: .word 2
col1: .word 6
row2: .word 2
col2: .word 7
board:
.byte 4
.byte 8
.half 2 3 3 6 12 48 1 2 1 6 0 0 1 2 1 24 0 0 1 2 12 96 3 3 12 12 24 0 12 1 2 3 

.text
.globl main
main:
la $a0, board
lw $a1, row1
lw $a2, col1
lw $a3, row2
lw $t0, col2
addi $sp, $sp, -4
sw $t0, 0($sp)
li $t0, 123456   # putting garbage in $t0 -- arg #5 is on the STACK
li $s0 -420
li $s1 -420
li $s2 -420
li $s3 -420
li $s4 -420
li $s5 -420
li $s6 -420
li $s7 -420
jal can_be_merged
addi $sp, $sp, 4

# Write your own code to print the return value.
move $a0, $v0
li $v0, 1
syscall

li $v0, 10
syscall

.include "proj3.asm"
