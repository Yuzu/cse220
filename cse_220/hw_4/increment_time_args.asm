# delta_mins is valid; queue is non-empty
.data
# garbage
.align 2
.space 5000
.word 0xffffffff 0xffffffff 0xffffffff 0x1
.space 5000
.word 0xabcdef09 0x12345678 0xfedcba01 0x291adead
.space 5000
__queue_bytes_length: .word 120
__pre_post_len: .word 32
# garbage
.align 2
.space 5000
.word 0xffffffff 0xffffffff 0xffffffff 0x1
.space 5000
.word 0xabcdef09 0x12345678 0xfedcba01 0x291adead
.space 5000
__delta_mins: .word 30
# garbage
.align 2
.space 5000
.word 0xffffffff 0xffffffff 0xffffffff 0x1
.space 5000
.word 0xabcdef09 0x12345678 0xfedcba01 0x291adead
.space 5000
__fame_level: .word 50
# garbage
.align 2
.space 5000
.word 0xffffffff 0xffffffff 0xffffffff 0x1
.space 5000
.word 0xabcdef09 0x12345678 0xfedcba01 0x291adead
.space 5000
__queue:
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

__queue_post: .ascii "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
# garbage
.align 2
.space 5000
.word 0xffffffff 0xffffffff 0xffffffff 0x1
.space 5000
.word 0xabcdef09 0x12345678 0xfedcba01 0x291adead
.space 5000
.include "../run_test.asm"

# delta_mins is valid; queue is non-empty
.data
# garbage
.align 2
.space 5000
.word 0xffffffff 0xffffffff 0xffffffff 0x1
.space 5000
.word 0xabcdef09 0x12345678 0xfedcba01 0x291adead
.space 5000
__queue_bytes_length: .word 160
__pre_post_len: .word 32
# garbage
.align 2
.space 5000
.word 0xffffffff 0xffffffff 0xffffffff 0x1
.space 5000
.word 0xabcdef09 0x12345678 0xfedcba01 0x291adead
.space 5000
__delta_mins: .word 20
# garbage
.align 2
.space 5000
.word 0xffffffff 0xffffffff 0xffffffff 0x1
.space 5000
.word 0xabcdef09 0x12345678 0xfedcba01 0x291adead
.space 5000
__fame_level: .word 50
# garbage
.align 2
.space 5000
.word 0xffffffff 0xffffffff 0xffffffff 0x1
.space 5000
.word 0xabcdef09 0x12345678 0xfedcba01 0x291adead
.space 5000
__queue:
.align 2
.half 18  # size
.half 20  # max_size
# index 0
.word 632  # id number
.half 95  # fame
.half 26  # wait_time
# index 1
.word 690  # id number
.half 88  # fame
.half 26  # wait_time
# index 2
.word 731  # id number
.half 84  # fame
.half 23  # wait_time
# index 3
.word 814  # id number
.half 45  # fame
.half 21  # wait_time
# index 4
.word 489  # id number
.half 25  # fame
.half 29  # wait_time
# index 5
.word 557  # id number
.half 46  # fame
.half 30  # wait_time
# index 6
.word 194  # id number
.half 96  # fame
.half 8  # wait_time
# index 7
.word 447  # id number
.half 95  # fame
.half 1  # wait_time
# index 8
.word 36  # id number
.half 13  # fame
.half 12  # wait_time
# index 9
.word 831  # id number
.half 61  # fame
.half 11  # wait_time
# index 10
.word 111  # id number
.half 38  # fame
.half 20  # wait_time
# index 11
.word 155  # id number
.half 59  # fame
.half 15  # wait_time
# index 12
.word 646  # id number
.half 70  # fame
.half 18  # wait_time
# index 13
.word 603  # id number
.half 41  # fame
.half 8  # wait_time
# index 14
.word 45  # id number
.half 2  # fame
.half 5  # wait_time
# index 15
.word 229  # id number
.half 75  # fame
.half 0  # wait_time
# index 16
.word 254  # id number
.half 6  # fame
.half 1  # wait_time
# index 17
.word 772  # id number
.half 72  # fame
.half 20  # wait_time
# index 18
.word 0  # id number
.half 0  # fame
.half 0  # wait_time
# index 19
.word 0  # id number
.half 0  # fame
.half 0  # wait_time

__queue_post: .ascii "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
# garbage
.align 2
.space 5000
.word 0xffffffff 0xffffffff 0xffffffff 0x1
.space 5000
.word 0xabcdef09 0x12345678 0xfedcba01 0x291adead
.space 5000
.include "../run_test.asm"

# delta_mins is valid; queue is non-empty
.data
# garbage
.align 2
.space 5000
.word 0xffffffff 0xffffffff 0xffffffff 0x1
.space 5000
.word 0xabcdef09 0x12345678 0xfedcba01 0x291adead
.space 5000
__queue_bytes_length: .word 160
__pre_post_len: .word 32
# garbage
.align 2
.space 5000
.word 0xffffffff 0xffffffff 0xffffffff 0x1
.space 5000
.word 0xabcdef09 0x12345678 0xfedcba01 0x291adead
.space 5000
__delta_mins: .word 15
# garbage
.align 2
.space 5000
.word 0xffffffff 0xffffffff 0xffffffff 0x1
.space 5000
.word 0xabcdef09 0x12345678 0xfedcba01 0x291adead
.space 5000
__fame_level: .word 25
# garbage
.align 2
.space 5000
.word 0xffffffff 0xffffffff 0xffffffff 0x1
.space 5000
.word 0xabcdef09 0x12345678 0xfedcba01 0x291adead
.space 5000
__queue:
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

__queue_post: .ascii "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
# garbage
.align 2
.space 5000
.word 0xffffffff 0xffffffff 0xffffffff 0x1
.space 5000
.word 0xabcdef09 0x12345678 0xfedcba01 0x291adead
.space 5000
.include "../run_test.asm"

