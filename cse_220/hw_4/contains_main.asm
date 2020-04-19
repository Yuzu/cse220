.data

queue:
.align 2
.half 28  # size
.half 35  # max_size
# index 0
.word 579  # id number
.half 829  # fame
.half 30  # wait_time
# index 1
.word 915  # id number
.half 788  # fame
.half 20  # wait_time
# index 2
.word 14  # id number
.half 918  # fame
.half 11  # wait_time
# index 3
.word 624  # id number
.half 655  # fame
.half 16  # wait_time
# index 4
.word 744  # id number
.half 840  # fame
.half 2  # wait_time
# index 5
.word 346  # id number
.half 568  # fame
.half 12  # wait_time
# index 6
.word 852  # id number
.half 644  # fame
.half 11  # wait_time
# index 7
.word 514  # id number
.half 742  # fame
.half 26  # wait_time
# index 8
.word 683  # id number
.half 611  # fame
.half 28  # wait_time
# index 9
.word 854  # id number
.half 498  # fame
.half 16  # wait_time
# index 10
.word 685  # id number
.half 430  # fame
.half 11  # wait_time
# index 11
.word 523  # id number
.half 33  # fame
.half 27  # wait_time
# index 12
.word 773  # id number
.half 661  # fame
.half 5  # wait_time
# index 13
.word 323  # id number
.half 13  # fame
.half 12  # wait_time
# index 14
.word 936  # id number
.half 499  # fame
.half 21  # wait_time
# index 15
.word 269  # id number
.half 175  # fame
.half 10  # wait_time
# index 16
.word 495  # id number
.half 212  # fame
.half 26  # wait_time
# index 17
.word 906  # id number
.half 76  # fame
.half 23  # wait_time
# index 18
.word 468  # id number
.half 397  # fame
.half 18  # wait_time
# index 19
.word 798  # id number
.half 345  # fame
.half 0  # wait_time
# index 20
.word 194  # id number
.half 601  # fame
.half 2  # wait_time
# index 21
.word 526  # id number
.half 445  # fame
.half 21  # wait_time
# index 22
.word 352  # id number
.half 535  # fame
.half 25  # wait_time
# index 23
.word 235  # id number
.half 416  # fame
.half 17  # wait_time
# index 24
.word 552  # id number
.half 654  # fame
.half 25  # wait_time
# index 25
.word 931  # id number
.half 62  # fame
.half 20  # wait_time
# index 26
.word 295  # id number
.half 507  # fame
.half 30  # wait_time
# index 27
.word 783  # id number
.half 646  # fame
.half 23  # wait_time
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
customer_id: .word 295


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
