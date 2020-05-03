.data

num: .word 232
list:
.word 8  # list's size
.word node970 # address of list's head
node622:
.word 887
.word node123
node273:
.word 34
.word node300
node347:
.word 887
.word node273
node285:
.word 493
.word node762
node300:
.word 232
.word 0
node970:
.word 34
.word node622
node762:
.word 232
.word node347
node123:
.word 232
.word node285


newline: .asciiz "\n"

.text
.globl main
main:
la $a0, list
lw $a1, num
jal remove

# Write your own code here to verify that the function is correct.

move $s0, $v0
move $s1, $v1

li $v0, 1
move $a0, $s0
syscall

li $v0, 4
la $a0, newline
syscall

li $v0, 1
move $a0, $s1
syscall

li $v0, 4
la $a0, newline
syscall

la $t0, list # load list address into $t0

lw $t1, 0($t0) # load list size into $t1 

# print list size
li $v0, 1
move $a0, $t1
syscall

li $v0, 4
la $a0, newline
syscall

li $v0, 4
la $a0, newline
syscall

la $t0, list # load list address into $t0
lw $t1, 4($t0) # load head address into $t1.
beqz $t1, for_print_LL_done
for_print_LL:
	lw $t2, 0($t1) # load node's num into $t2
	
	# print node's num
	li $v0, 1
	move $a0, $t2
	syscall
	
	# print newline
	li $v0, 4
	la $a0, newline
	syscall
	
	lw $t2, 4($t1) # load address of next node
	
	beqz $t2, for_print_LL_done # null terminator
	# else we continue
	move $t1, $t2
	j for_print_LL
	
for_print_LL_done:

li $v0, 10
syscall

.include "proj5.asm"
