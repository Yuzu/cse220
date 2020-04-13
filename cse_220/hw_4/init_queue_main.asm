.data
.align 2
# random garbage
queue:
.half 111
.half 200
.byte 14 69 23 197 105 69 28 215 231 224 10 98 138 144 86 88
max_size: .word 6

.text
.globl main
main:
la $a0, queue
lw $a1, max_size
jal init_queue

# We are late enough in the semester that you can take care of printing
# the results of the function call.

li $v0, 10
syscall

.include "proj4.asm"