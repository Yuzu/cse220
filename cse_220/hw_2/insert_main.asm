.data
str: .ascii "myname\0\0"  # note how a little garbage has been added past the string
ch: .byte 'X'
v0: .asciiz "$v0: "
msg: .asciiz "str: "
.align 2
index: .word 1

.text
.globl main
main:
la $a0, str
lbu $a1, ch
lw $a2, index
jal insert

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
li $v0, 4
la $a0, msg
syscall

li $v0, 4
la $a0, str
syscall

li $v0, 11
li $a0, '\n'
syscall

li $v0, 10
syscall
.include "proj2.asm"
