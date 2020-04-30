.data
list:
.word 5  # list's size
.word node761 # address of list's head
node168:
.word 402
.word 0
node814:
.word 978
.word node248
node761:
.word 962
.word node112
node248:
.word 526
.word node168
node112:
.word 762
.word node814

num: .word 24
index: .word 3


.text
.globl main
main:
la $a0, list
lw $a1, num
lw $a2, index
jal insert

# Write your own code here to verify that the function is correct.

li $v0, 10
syscall

.include "proj5.asm"
