.data
.align 2
queue:
.align 2
.half 25  # size
.half 35  # max_size
# index 0
.word 63  # id number
.half 622  # fame
.half 17  # wait_time
# index 1
.word 559  # id number
.half 48  # fame
.half 1  # wait_time
# index 2
.word 598  # id number
.half 124  # fame
.half 26  # wait_time
# index 3
.word 635  # id number
.half 859  # fame
.half 29  # wait_time
# index 4
.word 500  # id number
.half 844  # fame
.half 24  # wait_time
# index 5
.word 154  # id number
.half 779  # fame
.half 29  # wait_time
# index 6
.word 548  # id number
.half 84  # fame
.half 2  # wait_time
# index 7
.word 140  # id number
.half 525  # fame
.half 13  # wait_time
# index 8
.word 639  # id number
.half 402  # fame
.half 24  # wait_time
# index 9
.word 534  # id number
.half 691  # fame
.half 17  # wait_time
# index 10
.word 996  # id number
.half 354  # fame
.half 4  # wait_time
# index 11
.word 876  # id number
.half 43  # fame
.half 22  # wait_time
# index 12
.word 61  # id number
.half 384  # fame
.half 5  # wait_time
# index 13
.word 436  # id number
.half 578  # fame
.half 27  # wait_time
# index 14
.word 949  # id number
.half 914  # fame
.half 11  # wait_time
# index 15
.word 558  # id number
.half 397  # fame
.half 20  # wait_time
# index 16
.word 712  # id number
.half 331  # fame
.half 28  # wait_time
# index 17
.word 76  # id number
.half 97  # fame
.half 15  # wait_time
# index 18
.word 939  # id number
.half 331  # fame
.half 8  # wait_time
# index 19
.word 475  # id number
.half 545  # fame
.half 19  # wait_time
# index 20
.word 649  # id number
.half 645  # fame
.half 21  # wait_time
# index 21
.word 601  # id number
.half 564  # fame
.half 14  # wait_time
# index 22
.word 312  # id number
.half 579  # fame
.half 30  # wait_time
# index 23
.word 865  # id number
.half 680  # fame
.half 30  # wait_time
# index 24
.word 726  # id number
.half 743  # fame
.half 4  # wait_time
# index 25
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 26
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 27
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 28
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 29
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 30
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 31
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 32
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 33
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 34
.word 0  # id number
.half 0  # fame
.half 0  # wait_time



.text
.globl main
main:
la $a0, queue
li $s0 -420
li $s1 -420
li $s2 -420
li $s3 -420
li $s4 -420
li $s5 -420
li $s6 -420
li $s7 -420


jal build_heap

move $t0, $v0

# We are late enough in the semester that you can take care of printing
# the results of the function call.

li $v0, 1
move $a0, $t0
syscall


li $v0, 10
syscall

.include "proj4.asm"
