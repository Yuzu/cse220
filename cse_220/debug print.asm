# data stuff
space: .asciiz " "
newline: .asciiz "\n"


li $v0, 4
la $a0, space
syscall

li $v0, 4
la $a0, newline
syscall