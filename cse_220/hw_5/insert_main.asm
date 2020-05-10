.data
num: .word 24
index: .word 3
list:
.word 6  # list's size
.word node761 # address of list's head
node130:
.word 293
.word 0
node248:
.word 526
.word node168
node112:
.word 762
.word node814
node814:
.word 978
.word node248
node761:
.word 962
.word node112
node168:
.word 402
.word node130


newline: .asciiz "\n"
.text
.globl main
main:
la $a0, list
lw $a1, num
lw $a2, index
jal insert

# Write your own code here to verify that the function is correct.
la $t0, list # load list address into $t0

lw $t1, 0($a0) # load list size into $t1 

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
