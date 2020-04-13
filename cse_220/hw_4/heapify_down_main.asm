.data
queue:
.align 2
.half 50  # size
.half 60  # max_size
# index 0
.word 703  # id number
.half 29  # fame
.half 10  # wait_time
# index 1
.word 431  # id number
.half 542  # fame
.half 2  # wait_time
# index 2
.word 901  # id number
.half 600  # fame
.half 27  # wait_time
# index 3
.word 595  # id number
.half 419  # fame
.half 17  # wait_time
# index 4
.word 917  # id number
.half 879  # fame
.half 8  # wait_time
# index 5
.word 231  # id number
.half 928  # fame
.half 23  # wait_time
# index 6
.word 481  # id number
.half 601  # fame
.half 15  # wait_time
# index 7
.word 219  # id number
.half 831  # fame
.half 17  # wait_time
# index 8
.word 55  # id number
.half 331  # fame
.half 14  # wait_time
# index 9
.word 316  # id number
.half 549  # fame
.half 21  # wait_time
# index 10
.word 610  # id number
.half 454  # fame
.half 6  # wait_time
# index 11
.word 565  # id number
.half 361  # fame
.half 28  # wait_time
# index 12
.word 732  # id number
.half 302  # fame
.half 8  # wait_time
# index 13
.word 493  # id number
.half 799  # fame
.half 4  # wait_time
# index 14
.word 564  # id number
.half 656  # fame
.half 28  # wait_time
# index 15
.word 433  # id number
.half 907  # fame
.half 25  # wait_time
# index 16
.word 183  # id number
.half 116  # fame
.half 9  # wait_time
# index 17
.word 476  # id number
.half 899  # fame
.half 30  # wait_time
# index 18
.word 756  # id number
.half 12  # fame
.half 21  # wait_time
# index 19
.word 677  # id number
.half 161  # fame
.half 21  # wait_time
# index 20
.word 432  # id number
.half 744  # fame
.half 2  # wait_time
# index 21
.word 571  # id number
.half 520  # fame
.half 16  # wait_time
# index 22
.word 772  # id number
.half 983  # fame
.half 30  # wait_time
# index 23
.word 291  # id number
.half 593  # fame
.half 22  # wait_time
# index 24
.word 608  # id number
.half 685  # fame
.half 14  # wait_time
# index 25
.word 746  # id number
.half 458  # fame
.half 15  # wait_time
# index 26
.word 391  # id number
.half 18  # fame
.half 20  # wait_time
# index 27
.word 795  # id number
.half 705  # fame
.half 8  # wait_time
# index 28
.word 144  # id number
.half 802  # fame
.half 21  # wait_time
# index 29
.word 998  # id number
.half 796  # fame
.half 12  # wait_time
# index 30
.word 413  # id number
.half 926  # fame
.half 27  # wait_time
# index 31
.word 656  # id number
.half 396  # fame
.half 10  # wait_time
# index 32
.word 328  # id number
.half 412  # fame
.half 18  # wait_time
# index 33
.word 670  # id number
.half 998  # fame
.half 21  # wait_time
# index 34
.word 338  # id number
.half 566  # fame
.half 14  # wait_time
# index 35
.word 419  # id number
.half 524  # fame
.half 23  # wait_time
# index 36
.word 607  # id number
.half 333  # fame
.half 15  # wait_time
# index 37
.word 621  # id number
.half 128  # fame
.half 0  # wait_time
# index 38
.word 964  # id number
.half 135  # fame
.half 12  # wait_time
# index 39
.word 889  # id number
.half 971  # fame
.half 6  # wait_time
# index 40
.word 828  # id number
.half 423  # fame
.half 8  # wait_time
# index 41
.word 55  # id number
.half 401  # fame
.half 24  # wait_time
# index 42
.word 575  # id number
.half 337  # fame
.half 26  # wait_time
# index 43
.word 51  # id number
.half 542  # fame
.half 8  # wait_time
# index 44
.word 34  # id number
.half 953  # fame
.half 10  # wait_time
# index 45
.word 774  # id number
.half 950  # fame
.half 0  # wait_time
# index 46
.word 297  # id number
.half 977  # fame
.half 14  # wait_time
# index 47
.word 75  # id number
.half 614  # fame
.half 15  # wait_time
# index 48
.word 746  # id number
.half 548  # fame
.half 28  # wait_time
# index 49
.word 803  # id number
.half 566  # fame
.half 4  # wait_time
# index 50
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 51
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 52
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 53
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 54
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 55
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 56
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 57
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 58
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 59
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
index: .word 1


.text
.globl main
main:
la $a0, queue
lw $a1, index
jal heapify_down

# We are late enough in the semester that you can take care of printing
# the results of the function call.

li $v0, 10
syscall

.include "proj4.asm"
