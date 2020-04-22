.data
num_admitted: .word 2
budget: .word 2
admitted:
.word 952  # id number
.half 15  # fame
.half 2  # wait_time
.word 423  # id number
.half 10  # fame
.half 1  # wait_time


newline: .asciiz "\n"
.text
.globl main
main:
la $a0, admitted
lw $a1, num_admitted
lw $a2, budget
li $s0 -420
li $s1 -420
li $s2 -420
li $s3 -420
li $s4 -420
li $s5 -420
li $s6 -420
li $s7 -420


jal seat_customers
move $t0, $v0
move $t1, $v1
# We are late enough in the semester that you can take care of printing
# the results of the function call.

# ex 3 doesn't work.

li $v0, 35
move $a0, $t0
syscall

li $v0, 4
la $a0, newline
syscall

li $v0, 1
move $a0, $t0
syscall

li $v0, 4
la $a0, newline
syscall

li $v0, 1
move $a0, $t1
syscall

li $v0, 10
syscall

.include "proj4.asm"
