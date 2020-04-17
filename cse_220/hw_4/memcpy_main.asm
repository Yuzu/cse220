.data
.align 2
n: .word 0
src: .asciiz "ABCDEFG"
dest: .asciiz "xxxxxxxxx"
space: .asciiz " "
newline: .asciiz "\n"

.text
.globl main
main:
la $a0, src
la $a1, dest
lw $a2, n
jal memcpy

# We are late enough in the semester that you can take care of printing
# the results of the function call.
move $t0, $v0

li $v0, 1
move $a0, $t0
syscall

li $v0, 4
la $a0, newline
syscall


li $v0, 4
la $a0, dest
syscall

li $v0, 10
syscall

.include "proj4.asm"
