.data
.align 2
queue:
.half 15  # size
.half 18  # max_size
# index 0
.word 103  # id number
.half 1  # fame
.half 27  # wait_time
# index 1
.word 317  # id number
.half 258  # fame
.half 13  # wait_time
# index 2
.word 815  # id number
.half 730  # fame
.half 24  # wait_time
# index 3
.word 887  # id number
.half 182  # fame
.half 25  # wait_time
# index 4
.word 365  # id number
.half 889  # fame
.half 11  # wait_time
# index 5
.word 994  # id number
.half 104  # fame
.half 26  # wait_time
# index 6
.word 667  # id number
.half 330  # fame
.half 8  # wait_time
# index 7
.word 318  # id number
.half 565  # fame
.half 4  # wait_time
# index 8
.word 38  # id number
.half 431  # fame
.half 23  # wait_time
# index 9
.word 179  # id number
.half 346  # fame
.half 21  # wait_time
# index 10
.word 135  # id number
.half 81  # fame
.half 27  # wait_time
# index 11
.word 400  # id number
.half 327  # fame
.half 25  # wait_time
# index 12
.word 281  # id number
.half 749  # fame
.half 15  # wait_time
# index 13
.word 5  # id number
.half 181  # fame
.half 2  # wait_time
# index 14
.word 519  # id number
.half 346  # fame
.half 21  # wait_time
# index 15
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 16
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 17
.word 0  # id number
.half 0  # fame
.half 0  # wait_time


.text
.globl main
main:
la $a0, queue
jal build_heap
jal enqueue

# We are late enough in the semester that you can take care of printing
# the results of the function call.

li $v0, 10
syscall

.include "proj4.asm"
