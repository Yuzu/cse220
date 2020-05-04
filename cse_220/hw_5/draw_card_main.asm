.data

list:
.word 5  # list's size
.word node276 # address of list's head
node21:
.word 4739396
.word node519
node86:
.word 4740164
.word 0
node507:
.word 5452868
.word node21
node519:
.word 5452356
.word node86
node276:
.word 4733252
.word node507

newline: .asciiz "\n"
.text
.globl main
main:
la $a0, list
jal draw_card

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
	li $v0, 34
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
