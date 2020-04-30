.data
list: .word 0x48278291 0x92FEC713  # garbage

.text
.globl main
main:
la $a0, list
jal init_list

# Write your own code here to verify that the function is correct.

li $v0, 10
syscall

.include "proj5.asm"
