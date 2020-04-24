.data
num_admitted: .word 8
budget: .word 20
admitted:
.word 508  # id number
.half 15  # fame
.half 9  # wait_time
.word 678  # id number
.half 5  # fame
.half 9  # wait_time
.word 91  # id number
.half 7  # fame
.half 8  # wait_time
.word 996  # id number
.half 8  # fame
.half 7  # wait_time
.word 819  # id number
.half 11  # fame
.half 5  # wait_time
.word 880  # id number
.half 7  # fame
.half 5  # wait_time
.word 209  # id number
.half 12  # fame
.half 4  # wait_time
.word 975  # id number
.half 8  # fame
.half 2  # wait_time


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
