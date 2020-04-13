.data
queue:
.align 2
.half 10  # size
.half 15  # max_size
# index 0
.word 606  # id number
.half 89  # fame
.half 24  # wait_time
# index 1
.word 419  # id number
.half 90  # fame
.half 17  # wait_time
# index 2
.word 347  # id number
.half 80  # fame
.half 9  # wait_time
# index 3
.word 120  # id number
.half 13  # fame
.half 0  # wait_time
# index 4
.word 883  # id number
.half 49  # fame
.half 5  # wait_time
# index 5
.word 311  # id number
.half 49  # fame
.half 20  # wait_time
# index 6
.word 161  # id number
.half 89  # fame
.half 16  # wait_time
# index 7
.word 231  # id number
.half 29  # fame
.half 0  # wait_time
# index 8
.word 687  # id number
.half 10  # fame
.half 11  # wait_time
# index 9
.word 163  # id number
.half 9  # fame
.half 16  # wait_time
# index 10
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 11
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 12
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 13
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 14
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
delta_mins: .word 30
fame_level: .word 50


.text
.globl main
main:
la $a0, queue
lw $a1, delta_mins
lw $a2, fame_level

# We are late enough in the semester that you can take care of printing
# the results of the function call.

li $v0, 10
syscall

.include "proj4.asm"
