.data
.align 2
queue:
.align 2
.half 5  # size
.half 8  # max_size
# index 0
.word 696  # id number
.half 948  # fame
.half 6  # wait_time
# index 1
.word 703  # id number
.half 674  # fame
.half 2  # wait_time
# index 2
.word 855  # id number
.half 354  # fame
.half 25  # wait_time
# index 3
.word 902  # id number
.half 321  # fame
.half 2  # wait_time
# index 4
.word 992  # id number
.half 492  # fame
.half 3  # wait_time
# index 5
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 6
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 7
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
admitted:
.word 63  # id number
.half 920  # fame
.half 15  # wait_time
.word 486  # id number
.half 82  # fame
.half 5  # wait_time
.word 484  # id number
.half 999  # fame
.half 27  # wait_time
.word 368  # id number
.half 542  # fame
.half 19  # wait_time
.word 331  # id number
.half 282  # fame
.half 11  # wait_time
max_admits: .word 10




.text
.globl main
main:
la $a0, queue
lw $a1, max_admits
la $a2, admitted
li $s0 -420
li $s1 -420
li $s2 -420
li $s3 -420
li $s4 -420
li $s5 -420
li $s6 -420
li $s7 -420


jal admit_customers
move $t0, $v0
# We are late enough in the semester that you can take care of printing
# the results of the function call.

li $v0, 1
move $a0, $t0
syscall

li $v0, 10
syscall

.include "proj4.asm"
