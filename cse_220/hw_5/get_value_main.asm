.data
list:
.word 5  # list's size
.word node566 # address of list's head
node381:
.word 568
.word node275
node275:
.word 496
.word node393
node393:
.word 9
.word 0
node985:
.word 407
.word node381
node566:
.word 386
.word node985

index: .word 0

.text
.globl main
main:
la $a0, list
lw $a1, index
jal get_value

# Write your own code here to verify that the function is correct.

li $v0, 10
syscall

.include "proj5.asm"
