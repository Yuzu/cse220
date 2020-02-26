.data
str: .ascii "acadZacabaZcbacZeabZaQ\0*!??"
first: .byte 'X'
second: .byte 'Y'
char: .byte 'Z'
v0: .asciiz "$v0: "
msg: .asciiz "str: "
.align 2
start_index: .word 0

.text
.globl main
main:
la $a0, str
lbu $a1, char
lbu $a2, first
lbu $a3, second
addi $sp, $sp, -4
lw $t0, start_index
sw $t0, 0($sp)
li $t0, 125245  # trashing $t0 before function call
jal replace_first_char
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


