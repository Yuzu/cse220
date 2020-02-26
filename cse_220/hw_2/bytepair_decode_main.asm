.data
str: .asciiz "SoUZTVnWYsXy\0********"
replacements: .ascii "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0stoonykuiviterbr"
v0: .asciiz "$v0: "
msg: .asciiz "str: "

.text
.globl main
main:
la $a0, str
la $a1, replacements
jal bytepair_decode

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

li $v0, 10
syscall

.include "proj2.asm"