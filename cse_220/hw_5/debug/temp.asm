
# this is for the first round

addi $sp, $sp, -4 # we need to preserve the $v0 register to add to the running sum (overwritten by compare_ranks), no more $s registers so we have to use the stack.
	sw $v0, 0($sp)

lw $v0, 0($sp) # restore return value from play_card earlier.
	addi $sp, $sp, 4
	
	
	
	
# below is for the main loop

addi $sp, $sp, -4 # we need to preserve the $v0 register to add to the running sum (overwritten by compare_ranks), no more $s registers so we have to use the stack.
		sw $v0, 0($sp)
	

lw $v0, 0($sp) # restore return value from play_card earlier.
		addi $sp, $sp, 4