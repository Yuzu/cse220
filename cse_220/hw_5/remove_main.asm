.data
num: .word 12
list:
.word 0  # list's size
.word 0  # address of list's head (null)

.text
.globl main
main:
la $a0, list
lw $a1, num
jal remove

# Write your own code here to verify that the function is correct.

li $v0, 10
syscall

.include "proj5.asm"
