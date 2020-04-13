.data
queue:
.align 2
.half 5  # size
.half 8  # max_size
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
# index 6
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 7
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
customer_id: .word 788

.text
.globl main
main:
la $a0, queue
lw $a1, customer_id
jal contains

# We are late enough in the semester that you can take care of printing
# the results of the function call.

li $v0, 10
syscall

.include "proj4.asm"
