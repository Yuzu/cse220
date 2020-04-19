.data
queue:
.align 2
.half 5  # size
.half 6  # max_size
# index 0
.word 111  # id number
.half 859  # fame
.half 28  # wait_time
# index 1
.word 550  # id number
.half 576  # fame
.half 10  # wait_time
# index 2
.word 788  # id number
.half 418  # fame
.half 8  # wait_time
# index 3
.word 896  # id number
.half 40  # fame
.half 12  # wait_time
# index 4
.word 54  # id number
.half 275  # fame
.half 2  # wait_time
# index 5
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
dequeued_customer:  # garbage
.word 349  # id number
.half 873  # fame
.half 1  # wait_time




newline: .asciiz "\n"
space: .asciiz  " "

.text
.globl main
main:
la $a0, queue
la $a1, dequeued_customer
jal dequeue

la $t0, dequeued_customer
lw $s1, 0($t0) # customer data
lh $s2, 4($t0)
lh $s3, 6($t0)
move $s4, $v0 # return value

li $v0, 1
move $a0, $s1
syscall

li $v0, 4
la $a0, newline
syscall

li $v0, 1
move $a0, $s2
syscall

li $v0, 4
la $a0, newline
syscall

li $v0, 1
move $a0, $s3
syscall

li $v0, 4
la $a0, newline
syscall

li $v0, 1
move $a0, $s4
syscall

li $v0, 4
la $a0, newline
syscall

# call contains and check if customer is still there.

la $a0, queue
li $a1, 346

jal contains

move $s5, $v0

li $v0, 1
move $a0, $s5
syscall

li $v0, 4
la $a0, newline
syscall

li $v0, 10
syscall

.include "proj4.asm"
