.text
.globl main
main:
jal create_deck

# Write your own code here to verify that the function is correct.

li $v0, 10
syscall

.include "proj5.asm"
