.data
.align 2
n: .word 3
src: .asciiz "ABCDEFG"
dest: .asciiz "xxxxxxxxx"

.text
.globl main
main:
la $a0, src
la $a1, dest
lw $a2, n
jal memcpy

# We are late enough in the semester that you can take care of printing
# the results of the function call.

li $v0, 10
syscall

.include "proj4.asm"