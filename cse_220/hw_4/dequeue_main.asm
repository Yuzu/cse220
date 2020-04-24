.data
queue:
.align 2
.half 0  # size
.half 5  # max_size
# index 0
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 1
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 2
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 3
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 4
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
dequeued_customer:  # garbage
.word 346  # id number
.half 568  # fame
.half 12  # wait_time




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

# first 3 lines are customer data
# 4th line is return value
# 5th line is contains function call, -1 means not there.

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
