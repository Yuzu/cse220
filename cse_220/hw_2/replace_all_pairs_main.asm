.data
v0: .asciiz "$v0: "
msg: .asciiz "str: "
str: .asciiz "aabbacbacbacbacbababababcabbacabcacabcbacbabcacbabbacbcabcababa"
first: .byte 'b'
second: .byte 'a'
replacement_char: .byte 'Z'

.text
.globl main
main:
la $a0, str
lbu $a1, first
lbu $a2, second
lbu $a3, replacement_char
li $v0, 7777    # trashing $v0
jal replace_all_pairs

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
