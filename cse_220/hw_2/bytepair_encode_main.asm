.data
v0: .asciiz "$v0: "
msg: .asciiz "str: "
str: .asciiz "aabbacbacbacbacbababababcabbacabcacabcbacbabcacbabbacbcabcababa"
.align 2
frequencies: .space 676  # 26*26 = 676. DURING GRADING, this memory region will be filled with garbage.
garbage1: .ascii "qwerty"
.align 2
replacements: .space 52  # 26*2 = 52. DURING GRADING, this memory region will be filled with garbage.
garbage2: .ascii "asdfghj"

.text
.globl main
main:
la $a0, str
la $a1, frequencies
la $a2, replacements
jal bytepair_encode

move $t0, $v0

# print function's return value
li $v0, 4
la $a0, v0
syscall

move $a0, $t0
li $v0, 1
syscall

li $v0, 11
li $a0, '\n'
syscall

# print updated contents of str
la $a0, msg
li $v0, 4
syscall

la $a0, str
li $v0, 4
syscall

li $a0, '\n'
li $v0, 11
syscall

# Write some code here to print the replacements[] array
# Remember that we write into the array backwards!

li $v0, 10
syscall

.include "proj2.asm"
