.data
newline: .asciiz "\n"

.text
.globl main
main:
li $s0 -420
li $s1 -420
li $s2 -420
li $s3 -420
li $s4 -420
li $s5 -420
li $s6 -420
li $s7 -420


jal create_deck

# Write your own code here to verify that the function is correct.
move $s5, $v0
move $t0, $s5 # load list address into $t0

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

move $t0, $s5 # load list address into $t0
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
