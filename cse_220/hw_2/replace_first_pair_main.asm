.data
v0: .asciiz "$v0: "
msg: .asciiz "str: "
str: .asciiz "Uppercase Is OK Too\0"
first: .byte 'T'
second: .byte 'o'
replacement_char: .byte 'S'
start_index: .word 0

.text
.globl main
main:

la $a0, str
lbu $a1, first
lbu $a2, second
lbu $a3, replacement_char
addi $sp, $sp, -4
lw $t0, start_index
sw $t0, 0($sp)
li $t0, 919293  # trashing $t0 before function call
jal replace_first_pair
addi $sp, $sp, 4

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
