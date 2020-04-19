.data
.align 2
c1:
.word 1  # id number
.half 5000  # fame
.half 0  # wait_time
c2:
.word 2  # id number
.half 5  # fame
.half 60  # wait_time

.text
.globl main
main:
la $a0, c1
la $a1, c2
li $s0 -420
li $s1 -420
li $s2 -420
li $s3 -420
li $s4 -420
li $s5 -420
li $s6 -420
li $s7 -420

jal compare_to

# We are late enough in the semester that you can take care of printing
# the results of the function call.

move $t0, $v0

li $v0, 1
move $a0, $t0
syscall

li $v0, 10
syscall

.include "proj4.asm"
