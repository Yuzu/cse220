# Tim Wu
# TIMWU
# 112550028

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################

.text

# Part I
load_game_file:
	# $a0 stores the pointer to an unintialized GameBoard struct.
	# $a1 stores the name of the file.
	
	# Preserve saved registers.
	addi $sp, $sp, -20
	sw $s0, 0($sp) # Used as pointer to GameBoard
	sw $s1, 4($sp) # Used to keep track of how many insertions we've made. If this is greater than 2, we are working w/ shorts instead of bytes.
	sw $s2, 8($sp) # Used to store file descriptor
	sw $s3, 12($sp) # Used as running sum.
	sw $s4, 16($sp) # Used to keep track of magnitude of places (ones, tens, hundreds, etc)
	sw $s5, 20($sp) # Running sum to return.
	
	# Open file using syscall 13
	# Preserve stack args
	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $ra, 8($sp)
	
	li $v0, 13 # Syscall for opening file.
	move $a0, $a1 # Move filename into $a0 for syscall arg.
	li $a1, 0 # Load flag 0 for read-only
	li $a2, 0 # Mode arg is ignored. 
	syscall
	
	# Restore stack args
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	
	# File descriptor is returned in $v0. 
	# Return -1 if descriptor is negative.
	bgez $v0, no_file_error
	li $v0, -1
	jr $ra
	
	no_file_error:
	move $s2, $v0 # Store file descriptor in $s2
	
	# Read file contents using syscall 14
	move $s0, $a0 # Use $s0 as unchanged pointer to traverse through GameBoard.
	li $s1, 0 # 0 insertions made so far.
	li $s4, 1 # Initial multiply is by the 1s place.
	li $s5, 0 # Initialize running sum to return.
	for_read_file:
	
		# Preserve stack args
		addi $sp, $sp, -12
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $ra, 8($sp)
		
		addi $sp, $sp, -4 # Allocate buffer on stack to read the file.
		
		move $a0, $s2 # Move file descriptor into args.
		move $a1, $sp # Move address of buffer to args
		li $a2, 1 # Read 1 char at max.
		
		li $v0, 14 # Syscall for reading from file
		syscall
		
		beqz $v0, for_read_file_done # Return value of 0 indicates we've hit end-of-file
		bltz $v0, for_read_file_error # Neg return value indicates error.
		
		lbu $t0, 0($sp) # Move the letter we've read to $t0.
		addi $sp, $sp, 4 # Restore stack pointer
		
		# Restore stack args
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $ra, 8($sp)
		addi $sp, $sp, 12
		
		# Store character in GameBoard struct
		# Keep running sum in $s3 -> hit space means we store the value as a short and keep going.
		
		# These two conditions mean we've calculated the value for this current spot. 
		# We jump to store_value to store the running sum then zero it then loop back.
		
		li $t1, 32 # 32 is " " (a space) in ascii
		beq $t0, $t1, store_value # Loop over, we've seen all this value has to offer.
		li $t1, 10 # 10 is newline char
		beq $t0, $t1, store_value # We've hit a newline character, loop over.
		
		# Otherwise, we calculate the magnitude of this current digit and add it to the running sum.
		li $t2, 48 # Subtract offset of 48 to get ascii -> actual digit values.
		li $t1, 2
		ble $s1, $t1, calculating_byte # If we're inserting for the 1st or 2nd time, we need to insert a byte instead of a short.
		
		# Otherwise, we're calculating a short.
		li $t1, 10000 # Magnitude of short cannot be greater than 10,000s place.
		sub $t0, $t0, $t2 # $t0 = $t0 - $t2 | convert to actual digit value
		bgt $s4, $t1, store_value # Magnitude of this digit is greater than the max. Abort and just store the value we have now.
		mult $t0, $s4 # Multiply digit by magnitude place to get proper value.
		
		mflo $t0 # Store product in $t0
		add $s3, $s3, $t0 # Add product to running sum
		
		li $t1, 10
		mult $s4, $t1 # Look at next highest magnitude.
		mflo $s4
		
		j for_read_file
		
		calculating_byte:
			li $t1, 100 # Magnitude of byte cannot be greater than the 100s place.
			sub $t0, $t0, $t2 # $t0 = $t0 - $t2 | convert to actual digit value
			bgt $s4, $t1, store_value # Magnitude of this digit is greater than the max. Abort and just store the value we have now.
			mult $t0, $s4 # Multiply digit by magnitude place to get proper value.
			
			mflo $t0 # Store product in $t0
			add $s3, $s3, $t0 # Add product to running sum
			
			li $t1, 10
			mult $s4, $t1 # Look at next highest magnitude.
			mflo $s4
			
			j for_read_file
			
		store_value:
			
			
			addi $s1, $s1, 1 # Making an insertion.
			beqz $s3, inserting_zero
			addi $s5, $s5, 1 # Making a non-zero insertion.
			inserting_zero:
			
			# Given how we read the values, we need to flip the digits.
			
			# Move the value we have into a temp var since the algorithm will trash the value.
			move $t6, $s3 # i
			li $t7, 0 # r
			
			while_reverse_digits:
				li $t8, 10
	
				mult $t7, $t8 # r = r * 10
				mflo $t9 # t9 stores the updated r
	 
	 			div $t6, $t8 # Divide i by 10
	 			mflo $t6 # Set i = quotient
	 			mfhi $t5 # Set $t5 = remainder
	 
	 			add $t7, $t9, $t5 # Set r to r*10 + remainder
	 			bgtz $t6, while_reverse_digits
	 		
	 		move $s3, $t7
			li $t1, 2
			ble $s1, $t1, insert_byte
		
			# Otherwise we're inserting a short here.
			sh $s3, 0($s0)
			li $s3, 0 # Zero out the running sum
			li $s4, 1 # Reset place magnitude to ones place
			addi $s0, $s0, 2
			j for_read_file
		
			insert_byte:
			sb $s3, 0($s0)
			li $s3, 0  # Zero out the running sum
			li $s4, 1 # Reset place magnitude to ones place
			addi $s0, $s0, 1
			j for_read_file
			
	for_read_file_error:
		li $v0, -1
		jr $ra
		
	for_read_file_done:
	addi $s5, $s5, -2 # Subtract 2 to account for the 2 args we inserted.
	move $v0, $s5
	
	# Close file
	# Preserve $ra
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $v0, 16
	move $a0, $s2
	syscall
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	# Restore $s registers
	
	lw $s0, 0($sp) # Used as pointer to GameBoard
	lw $s1, 4($sp) # Used to keep track of how many insertions we've made. If this is greater than 2, we are working w/ shorts instead of bytes.
	lw $s2, 8($sp) # Used to store file descriptor
	lw $s3, 12($sp) # Used as running sum.
	lw $s4, 16($sp) # Used to keep track of magnitude of places (ones, tens, hundreds, etc)
	lw $s5, 20($sp) # Running sum to return.
	addi $sp, $sp, 20
	
	jr $ra

# Part II
save_game_file:
jr $ra

# Part III
get_tile:
jr $ra

# Part IV
set_tile:
jr $ra

# Part V
can_be_merged:
jr $ra

# Part VI
slide_row:
jr $ra

# Part VII
slide_col:
jr $ra

# Part VIII
slide_board_left:
jr $ra

# Part IX
slide_board_right:
jr $ra

# Part X
slide_board_up:
jr $ra

# Part XI
slide_board_down:
jr $ra

# Part XII
game_status:
jr $ra

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
