.data

queue:
.align 2
.half 5  # size
.half 8  # max_size
# index 0
.word 239  # id number
.half 558  # fame
.half 15  # wait_time
# index 1
.word 138  # id number
.half 468  # fame
.half 6  # wait_time
# index 2
.word 456  # id number
.half 388  # fame
.half 24  # wait_time
# index 3
.word 473  # id number
.half 46  # fame
.half 0  # wait_time
# index 4
.word 182  # id number
.half 158  # fame
.half 17  # wait_time
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
customer_id: .word 22


.text
.globl main
main:
la $a0, queue
lw $a1, customer_id
jal contains

# We are late enough in the semester that you can take care of printing
# the results of the function call.
move $t0, $v0

li $v0, 1
move $a0, $t0
syscall

li $v0, 10
syscall

.include "proj4.asm"
