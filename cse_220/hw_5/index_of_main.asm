.data

num: .word 912321
list:
.word 5  # list's size
.word node566 # address of list's head
node566:
.word 386
.word node985
node985:
.word 407
.word node381
node393:
.word 9
.word 0
node381:
.word 568
.word node275
node275:
.word 496
.word node393

.text
.globl main
main:
la $a0, list
lw $a1, num
jal index_of

# Write your own code here to verify that the function is correct.
move $t0, $v0

li $v0, 1
move $a0, $t0
syscall

li $v0, 10
syscall

.include "proj5.asm"
