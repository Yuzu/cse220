.data
.align 2
c1:
.word 1  # id number
.half 100  # fame
.half 10  # wait_time
c2:
.word 2  # id number
.half 50  # fame
.half 30  # wait_time

.text
.globl main
main:
la $a0, c1
la $a1, c2
jal compare_to

# We are late enough in the semester that you can take care of printing
# the results of the function call.

li $v0, 10
syscall

.include "proj4.asm"