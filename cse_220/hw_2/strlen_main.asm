.data
str: .asciiz "MIPS is fun!"
v0: .asciiz "$v0: "

.text
.globl main
main:
la $a0, str
jal strlen

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

li $v0, 10
syscall

.data
.include "proj2.asm"
