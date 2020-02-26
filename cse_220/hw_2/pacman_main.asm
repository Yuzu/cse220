.data
str: .ascii "abcdefoABCDEsthnb\0#"
v0: .asciiz "$v0: "
v1: .asciiz "$v1: "
msg: .asciiz "str: "
.text
.globl main
main:
la $a0, str
jal pacman

move $t0, $v0
move $t1, $v1

# print function's first return value
li $v0, 4
la $a0, v0
syscall

move $a0, $t0
li $v0, 1
syscall

li $v0, 11
li $a0, '\n'
syscall

# print function's second return value
li $v0, 4
la $a0, v1
syscall

move $a0, $t1
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

.data
.include "proj2.asm"
