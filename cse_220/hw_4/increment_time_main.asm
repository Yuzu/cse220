.data
queue:
.align 2
.half 18  # size
.half 20  # max_size
# index 0
.word 287  # id number
.half 34  # fame
.half 30  # wait_time
# index 1
.word 886  # id number
.half 43  # fame
.half 19  # wait_time
# index 2
.word 537  # id number
.half 25  # fame
.half 21  # wait_time
# index 3
.word 779  # id number
.half 80  # fame
.half 21  # wait_time
# index 4
.word 955  # id number
.half 1  # fame
.half 23  # wait_time
# index 5
.word 413  # id number
.half 58  # fame
.half 17  # wait_time
# index 6
.word 635  # id number
.half 83  # fame
.half 9  # wait_time
# index 7
.word 65  # id number
.half 1  # fame
.half 2  # wait_time
# index 8
.word 622  # id number
.half 56  # fame
.half 1  # wait_time
# index 9
.word 446  # id number
.half 89  # fame
.half 5  # wait_time
# index 10
.word 578  # id number
.half 15  # fame
.half 12  # wait_time
# index 11
.word 879  # id number
.half 8  # fame
.half 26  # wait_time
# index 12
.word 997  # id number
.half 97  # fame
.half 16  # wait_time
# index 13
.word 370  # id number
.half 29  # fame
.half 3  # wait_time
# index 14
.word 560  # id number
.half 9  # fame
.half 15  # wait_time
# index 15
.word 291  # id number
.half 52  # fame
.half 9  # wait_time
# index 16
.word 486  # id number
.half 23  # fame
.half 4  # wait_time
# index 17
.word 75  # id number
.half 17  # fame
.half 8  # wait_time
# index 18
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 19
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
delta_mins: .word 15
fame_level: .word 25

.text
.globl main
main:
la $a0, queue
lw $a1, delta_mins
lw $a2, fame_level
jal increment_time
move $t0, $v0
# We are late enough in the semester that you can take care of printing
# the results of the function call.

li $v0, 1
move $a0, $t0
syscall

li $v0, 10
syscall

.include "proj4.asm"
