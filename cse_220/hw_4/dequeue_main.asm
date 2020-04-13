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


.text
.globl main
main:
la $a0, queue
la $a1, dequeued_customer
jal enqueue

# We are late enough in the semester that you can take care of printing
# the results of the function call.

li $v0, 10
syscall

.include "proj4.asm"
