.data
.align 2
queue:
.align 2
.half 4  # size
.half 6  # max_size
# index 0
.word 28  # id number
.half 909  # fame
.half 20  # wait_time
# index 1
.word 642  # id number
.half 611  # fame
.half 22  # wait_time
# index 2
.word 905  # id number
.half 154  # fame
.half 0  # wait_time
# index 3
.word 855  # id number
.half 652  # fame
.half 26  # wait_time
# index 4
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 5
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
admitted:
.word 492  # id number
.half 281  # fame
.half 13  # wait_time
.word 284  # id number
.half 973  # fame
.half 12  # wait_time
.word 421  # id number
.half 879  # fame
.half 25  # wait_time
.word 205  # id number
.half 417  # fame
.half 12  # wait_time
.word 667  # id number
.half 408  # fame
.half 22  # wait_time
max_admits: .word 3


.text
.globl main
main:
la $a0, queue
lw $a1, max_admits
la $a2, admitted
jal admit_customers

# We are late enough in the semester that you can take care of printing
# the results of the function call.

li $v0, 10
syscall

.include "proj4.asm"
