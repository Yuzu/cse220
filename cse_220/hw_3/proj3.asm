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
	# $a0 has a pointer to a GameBoard
	# $a1 has the output filename address.
	
	# Preserve $s args
	addi $sp, $sp, -28
	sw $s0, 0($sp) # Number of digits, used to keep track of how many times we push onto the stack.
	sw $s1, 4($sp) # Used to preserve file descriptor.
	sw $s2, 8($sp) # "i" in loop for rows
	sw $s3, 12($sp) # stores row count
	sw $s4, 16($sp) # used as pointer to gameboard.
	sw $s5, 20($sp) # used to store column count
	sw $s6, 24($sp) # "j" in loop for columns
	
	# Preserve args before syscall
	addi $sp, $sp, -12 
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $ra, 8($sp)
	
	li $v0, 13
	move $a0, $a1 # Move filename to a0
	li $a1, 1 # Flag 1 for write
	li $a2, 0 # Mode is ignored
	syscall
	
	# Restore saved args
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	 
	move $s1, $v0 # Store file descriptor in $s1
	
	bltz $s1, save_file_error # Neg return value indicates an error occurred.
	j no_save_file_error
	
	save_file_error:
		li $v0, -1
		jr $ra
		
	no_save_file_error:
	
	# Loop through GameBoard. 
	# Mod 10 to get 1s place -> push onto stack -> remainder is 0 -> pop everything off to get reverse order to store (make sure to convert to ascii)
	
	# Get size of board to determine where to loop to | board size is 1 + 1 + (rows) x (columns) x (2)
	# Loop from 0 to (rows)(columns)(2) - 2
	
	lb $t1, 0($a0) # number of rows
	# ***** SAVE THE ROW COUNT *****
	li $t3, 10 # Used for mod division.
	li $s0, 0 # Number of digits, used to keep track of how many times we push onto the stack.
	
	while_save_rows:
	
	beqz $t1, store_rows # We've dealt w/ all the digits, 0/10 = 0. now to store the digits in reverse order.
	
	div $t1, $t3 # rows / 10 | EXAMPLE: 254 / 10 
	mfhi $t6 # Remainder, result of mod division | EXAMPLE: 4 stored
	mflo $t1 # Integer divison result | EXAMPLE: 25 stored, divide this by 10 next loop.
	
	# New digit, need to push onto stack.
	
	# Convert digit to ascii first.
	addi $t6, $t6, 48 # Convert to ascii
	addi $sp, $sp, -4
	sw $t6, 0($sp)
	addi $s0, $s0, 1 # Increment number of pushes.
	j while_save_rows
	
	store_rows:
	# Also clear stack, we need to pop the stuff we pushed.
	beqz $s0, while_save_rows_done
	move $fp, $sp # Store current stack pointer in $fp, we're gonna be pushing stuff onto the stack.
		
	# Preserve args before syscall
	addi $sp, $sp, -12 
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $ra, 8($sp)
		
	li $v0, 15
	move $a0, $s1 # file descriptor
	move $a1, $fp # address of buffer
	li $a2, 1 # max characters = hardcoded 1
	syscall
		
	# Restore saved args
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	
	addi $sp, $sp, 4 # Pop a character off the stack
	addi $s0, $s0, -1
	j store_rows
	
	store_rows_done:
	
	
	while_save_rows_done:
	move $fp, $sp # Restore $fp
	
	# ***** SAVE A SPACE IN THE FILE ******
	# Preserve args before syscall
	addi $sp, $sp, -12 
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $ra, 8($sp)
	
	li $t0, 32 # " " in ascii
	addi $sp, $sp, -4 # push space onto stack
	sw $t0, 0($sp)
	
	li $v0, 15
	move $a0, $s1 # file descriptor
	move $a1, $sp # file buffer
	li $a2, 1 # hardcoded len of 1
	syscall 
	
	addi $sp, $sp, 4 # get rid of buffer
	
	# Restore saved args
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	
	# *****SAVE COLUMN COUNT IN FILE******
	
	lb $t1, 1($a0) # number of columns
	
	li $t3, 10 # Used for mod division.
	li $s0, 0 # Number of digits, used to keep track of how many times we push onto the stack.
	
	while_save_columns:
	
	beqz $t1, store_columns # We've dealt w/ all the digits, 0/10 = 0. now to store the digits in reverse order.
	
	div $t1, $t3 # rows / 10 | EXAMPLE: 254 / 10 
	mfhi $t6 # Remainder, result of mod division | EXAMPLE: 4 stored
	mflo $t1 # Integer divison result | EXAMPLE: 25 stored, divide this by 10 next loop.
	
	# New digit, need to push onto stack.
	
	# Convert digit to ascii first.
	addi $t6, $t6, 48 # Convert to ascii
	addi $sp, $sp, -4
	sw $t6, 0($sp)
	addi $s0, $s0, 1 # Increment number of pushes.
	j while_save_columns
	
	store_columns:
	# Also clear stack, we need to pop the stuff we pushed.
	beqz $s0, while_save_columns_done
	move $fp, $sp # Store current stack pointer in $fp, we're gonna be pushing stuff onto the stack.
		
	# Preserve args before syscall
	addi $sp, $sp, -12 
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $ra, 8($sp)
		
	li $v0, 15
	move $a0, $s1 # file descriptor
	move $a1, $fp # address of buffer
	li $a2, 1 # max characters = hardcoded 1
	syscall
		
	# Restore saved args
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	
	addi $sp, $sp, 4 # Pop a character off the stack
	addi $s0, $s0, -1
	j store_columns
	
	store_columns_done:
	
	while_save_columns_done:
	move $fp, $sp # Restore $fp
	
	# ***** SAVE A NEWLINE IN THE FILE ******
	# Preserve args before syscall
	addi $sp, $sp, -12 
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $ra, 8($sp)
	
	li $t0, 10 # newline char in ascii
	addi $sp, $sp, -4 # push space onto stack
	sw $t0, 0($sp)
	
	li $v0, 15
	move $a0, $s1 # file descriptor
	move $a1, $sp # file buffer
	li $a2, 1 # hardcoded len of 1
	syscall 
	
	addi $sp, $sp, 4 # get rid of buffer
	
	# Restore saved args
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	
	
	# ***** STORE TILE VALUES *****
	
	lb $s3, 0($a0)
	lb $s5, 1($a0)
	
	# file descriptor still in $s1
	li $s2, 0 # "i" to count rows
	#rows in $s3
	move $s4, $a0 # use $s4 as pointer to gameboard
	addi $s4, $s4, 2 # Look past first two bytes. We already looked at those.
	# columns in $s5
	# "i" to count columns in $s6
	
	# Prevent OBOE
	addi $s5, $s5, -1 
	
	for_save_file_tiles:
		
		beq $s2, $s3, for_save_file_tiles_done # finished all rows
		
		li $t3, 10 # Used for mod division.
		li $s0, 0 # Number of digits, used to keep track of how many times we push onto the stack.
		lh $t1, 0($s4) # Load current short.
		
		beqz $t1, store_zero # Current short is 0, we need to store a 0 instead of going through all this.
		j while_save_tiles
		
		store_zero:
		# ***** SAVE A ZERO IN THE FILE ******
		# Preserve args before syscall
		addi $sp, $sp, -12 
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $ra, 8($sp)
	
		li $t0, 48 # "0" in ascii
		addi $sp, $sp, -4 # push space onto stack
		sw $t0, 0($sp)
	
		li $v0, 15
		move $a0, $s1 # file descriptor
		move $a1, $sp # file buffer
		li $a2, 1 # hardcoded len of 1
		syscall 
	
		addi $sp, $sp, 4 # get rid of buffer
	
		# Restore saved args
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $ra, 8($sp)
		addi $sp, $sp, 12
		
		j while_save_tiles_done
		
		while_save_tiles:
			
			beqz $t1, store_tiles # We've dealt w/ all the digits, 0/10 = 0. now to store the digits in reverse order.
	
			div $t1, $t3 # rows / 10 | EXAMPLE: 254 / 10 
			mfhi $t6 # Remainder, result of mod division | EXAMPLE: 4 stored
			mflo $t1 # Integer divison result | EXAMPLE: 25 stored, divide this by 10 next loop.
	
			# New digit, need to push onto stack.
	
			# Convert digit to ascii first.
			addi $t6, $t6, 48 # Convert to ascii
			addi $sp, $sp, -4
			sw $t6, 0($sp)
			addi $s0, $s0, 1 # Increment number of pushes.
			j while_save_tiles
	
			store_tiles:
			# Also clear stack, we need to pop the stuff we pushed.
			beqz $s0, while_save_tiles_done
			move $fp, $sp # Store current stack pointer in $fp, we're gonna be pushing stuff onto the stack.
		
			# Preserve args before syscall
			addi $sp, $sp, -12 
			sw $a0, 0($sp)
			sw $a1, 4($sp)
			sw $ra, 8($sp)
		
			li $v0, 15
			move $a0, $s1 # file descriptor
			move $a1, $fp # address of buffer
			li $a2, 1 # max characters = hardcoded 1
			syscall
		
			# Restore saved args
			lw $a0, 0($sp)
			lw $a1, 4($sp)
			lw $ra, 8($sp)
			addi $sp, $sp, 12
	
			addi $sp, $sp, 4 # Pop a character off the stack
			addi $s0, $s0, -1
			j store_tiles
	
			store_tiles_done:
	
		while_save_tiles_done:
		
	# Look at the next tile.
	addi $s4, $s4, 2 # Look at next tile
	
	beq $s6, $s5, end_of_row # if this is the end of the row, write a newline char, reset column counter ($s6), and increment row counter ($s2)
	addi $s6, $s6, 1 # Increment column counter
	j not_end_of_row
	
	end_of_row:
	
	# ***** SAVE A NEWLINE IN THE FILE ******
	# Preserve args before syscall
	addi $sp, $sp, -12 
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $ra, 8($sp)
	
	li $t0, 10 # newline char in ascii
	addi $sp, $sp, -4 # push space onto stack
	sw $t0, 0($sp)
	
	li $v0, 15
	move $a0, $s1 # file descriptor
	move $a1, $sp # file buffer
	li $a2, 1 # hardcoded len of 1
	syscall 
	
	addi $sp, $sp, 4 # get rid of buffer
	
	# Restore saved args
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	
	li $s6, 0 # reset column counter
	addi $s2, $s2, 1 # increment row counter
	
	j for_save_file_tiles
	
	not_end_of_row:
	# ***** SAVE A SPACE IN THE FILE ******
	# Preserve args before syscall
	addi $sp, $sp, -12 
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $ra, 8($sp)
	
	li $t0, 32 # " " in ascii
	addi $sp, $sp, -4 # push space onto stack
	sw $t0, 0($sp)
	
	li $v0, 15
	move $a0, $s1 # file descriptor
	move $a1, $sp # file buffer
	li $a2, 1 # hardcoded len of 1
	syscall 
	
	addi $sp, $sp, 4 # get rid of buffer
	
	# Restore saved args
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	
	j for_save_file_tiles
	
	for_save_file_tiles_done:
	
	# Restore $s args
	lw $s0, 0($sp) # Number of digits, used to keep track of how many times we push onto the stack.
	lw $s1, 4($sp) # Used to preserve file descriptor.
	lw $s2, 8($sp) # "i" in loop for rows
	lw $s3, 12($sp) # stores row count
	lw $s4, 16($sp) # used as pointer to gameboard.
	lw $s5, 20($sp) # used to store column count
	lw $s6, 24($sp) # "j" in loop for columns
	addi $sp, $sp, 28
	
	jr $ra

# Part III
get_tile:
	# $a0 has board
	# $a1 has row
	# $a2 has column
	
	lb $t0, 0($a0) # Load rows into $t0
	lb $t1, 1($a0) # Load columns into $t1
	
	# Negative is invalid. 0 and pos is ok.
	bltz $a1, invalid_get_dimension
	bltz $a2, invalid_get_dimension
	
	# valid range is the value [0, row -1] and same for column so if value >= dimension it's no good.
	bge $a1, $t0, invalid_get_dimension
	bge $a2, $t1, invalid_get_dimension
	
	j valid_get_dimension
	
	invalid_get_dimension:
		li $v0, -1
		jr $ra
		
	valid_get_dimension:
	
	# $a1 has target row
	# $a2 has target column
	
	# $t0 has number of rows
	# $t1 has number of columns
	move $t2, $a0 # Use $t2 as board pointer
	addi $t2, $t2, 2 # Ignore dimensions
	
	li $t3, 0 # Row counter
	
	get_tile_row_loop:
		li $t4, 0 # Column counter
		
		get_tile_column_loop:
			
			beq $t4, $a2, get_tile_correct_column # Correct column
			# Otherwise keep looking
			addi $t2, $t2, 2
			addi $t4, $t4, 1
			blt $t4, $t1, get_tile_column_loop
			j get_tile_column_loop_done
			
			get_tile_correct_column:
				beq $t3, $a1, get_tile_correct_row # Correct column and row means return this value.
				# Otherwise keep looking
				addi $t2, $t2, 2
				addi $t4, $t4, 1
				blt $t4, $t1, get_tile_column_loop
				j get_tile_column_loop_done
				
				get_tile_correct_row:
					# return the value here.
					lhu $v0, 0($t2)
					jr $ra
			
		get_tile_column_loop_done:
		addi $t3, $t3, 1
		blt $t3, $t0, get_tile_row_loop
		j get_tile_row_loop_done
		
	get_tile_row_loop_done:
	
	# Some other error
	li $v0, -1
	jr $ra

# Part IV
set_tile:
	# $a0 has board
	# $a1 has target row
	# $a2 has target column
	# $a3 has value to write
	
	lb $t0, 0($a0) # Load rows into $t0
	lb $t1, 1($a0) # Load columns into $t1
	
	# Negative is invalid. 0 and pos is ok.
	bltz $a1, invalid_set_dimension
	bltz $a2, invalid_set_dimension
	
	# valid range is the value [0, row -1] and same for column so if value >= dimension it's no good.
	bge $a1, $t0, invalid_set_dimension
	bge $a2, $t1, invalid_set_dimension
	
	j valid_set_dimension
	
	invalid_set_dimension:
		li $v0, -1
		jr $ra
		
	valid_set_dimension:
	
	li $t3, 49152
	
	bgt $a3, $t3, invalid_set_value # too big
	bltz $a3, invalid_set_value  # too small
	j valid_set_value
	
	invalid_set_value:
		li $v0, -1
		jr $ra
	
	valid_set_value:
	
	# $a1 has target row
	# $a2 has target column
	# $t0 has number of rows
	# $t1 has number of columns
	move $t2, $a0 # Use $t2 as board pointer
	addi $t2, $t2, 2 # Ignore dimensions
	
	li $t3, 0 # Row counter
	
	set_tile_row_loop:
		li $t4, 0 # Column counter
		
		set_tile_column_loop:
			
			beq $t4, $a2, set_tile_correct_column # Correct column
			# Otherwise keep looking
			addi $t2, $t2, 2
			addi $t4, $t4, 1
			blt $t4, $t1, set_tile_column_loop
			j set_tile_column_loop_done
			
			set_tile_correct_column:
				beq $t3, $a1, set_tile_correct_row # Correct column and row means return this value.
				# Otherwise keep looking
				addi $t2, $t2, 2
				addi $t4, $t4, 1
				blt $t4, $t1, set_tile_column_loop
				j set_tile_column_loop_done
				
				set_tile_correct_row:
					# return the value here.
					sh $a3, 0($t2)
					move $v0, $a3
					jr $ra
			
		set_tile_column_loop_done:
		addi $t3, $t3, 1
		blt $t3, $t0, set_tile_row_loop
		j set_tile_row_loop_done
		
	set_tile_row_loop_done:
	
	jr $ra

# Part V
can_be_merged:
	# $a0 has board
	# $a1 has row of 1st tile
	# $a2 has column of 1nd tile
	
	# $a3 has row of 2nd tile
	# 0($sp) has column of 2nd tile
	move $fp, $sp # move current $sp to $fp because we're pushing stuff. 
	# preserve $s registers
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	
	# $s0 has board dimension of row
	# $s1 has board dimension of column
	# $s2 has tile 1 value
	# $s3 has tile 2 value
	
	lb $s0, 0($a0)
	lb $s1, 1($a0)
	
	# get first tile value
	move $t0, $a1 # Store row in $t0
	move $t1, $a2 # Store column in $t1
	lw $t2, 0($fp)
	
	# Preserve args for function call
	addi $sp, $sp, -24
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $a3, 12($sp)
	sw $t2, 16($sp)
	sw $ra, 20($sp)
	
	# board still in $a0
	move $a1, $t0 # move row to $a1 arg
	move $a2, $t1 # move column to $a2 arg
	
	jal get_tile
	
	# Restore args
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a3, 12($sp)
	lw $t2, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
	
	blez $v0, merge_tile_get_error
	move $s2, $v0
	
	
	# get second tile value
	move $t0, $a3 # store row in $t0
	lw $t1, 0($fp) # store column in $t1
	
	# Preserve args for function call
	addi $sp, $sp, -24
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $a3, 12($sp)
	sw $t2, 16($sp)
	sw $ra, 20($sp)
	
	# board still in $a0
	move $a1, $t0 # move row to $a1 arg
	move $a2, $t1 # move column to $a2 arg
	
	jal get_tile
	
	# Restore args
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a3, 12($sp)
	lw $t2, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
	
	blez $v0, merge_tile_get_error
	move $s3, $v0
	
	j merge_tile_get_no_error
	
	merge_tile_get_error:
		
		# restore $s registers
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		addi $sp, $sp, 16
		
		li $v0, -1
		jr $ra
	merge_tile_get_no_error:
	
	# Check whether tile positions are ok  ( have to be adjacent)
	# range is already checked by the get_tile function already, returns -1 if invalid range.)
	
	# Difference in rows and columns must be <= 1
	
	li $t7, 1 
	
	move $t0, $a1 # row of tile 1
	move $t1, $a2 # col of tile 1
	
	move $t2, $a3 # row of tile 2
	lw $t3, 0($fp) # col of tile 2
	
	# check if they're the same tile.
	beq $t0, $t2, merge_tile_same_row
	j merge_tile_unique_tile
	
	merge_tile_same_row:
		beq $t1, $t3, merge_tile_same_tile
		j merge_tile_unique_tile
		
		merge_tile_same_tile:
			# Same tile, invalid merge.
			# restore $s registers
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $s2, 8($sp)
			lw $s3, 12($sp)
			addi $sp, $sp, 16
			
			li $v0, -1
			jr $ra
	
	merge_tile_unique_tile:
	
	# Check if tiles are adjacent
	subu $t4, $t0, $t2 # Difference of rows
	abs $t4, $t4 # convert to abs value
	bgt $t4, $t7, merge_tile_non_adjacent_error # If abs difference is > 1 then they're not adjacent.
	
	subu $t5, $t1, $t3 # Difference of columns
	abs $t5, $t5 # convert to abs value
	bgt $t5, $t7, merge_tile_non_adjacent_error # If abs difference is > 1 then they're not adjacent.
	
	j merge_tile_is_adjacent
	
	merge_tile_non_adjacent_error:
		# restore $s registers
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		addi $sp, $sp, 16
		
		li $v0, -1
		jr $ra
		
	merge_tile_is_adjacent:
	
	# Check if tiles are compatible or not
	# Compatible means either: 1 + 2, or dupes if >= 3
	
	# $s2 has tile 1 value
	# $s3 has tile 2 value
	
	# Check if 1 + 2 operation
	li $t0, 1
	li $t1, 2
	
	beq $s2, $t0, merge_tile_one_is_1 # Tile one = 1
	beq $s3, $t0, merge_tile_two_is_1 # Tile two = 1
	# No ones present, merging something else.
	j merge_other_values
	
	# 1 + ?
	merge_tile_one_is_1:
		# tile two has to be 2
		beq $s3, $t1, merge_1_plus_2 # tile two = 2
		j merge_invalid_error # tile two != 2
	
	# ? + 1
	merge_tile_two_is_1:
		# tile one has to be 2
		beq $s2, $t1, merge_1_plus_2 # tile one = 2
		j merge_invalid_error # tile one != 2
	
	merge_1_plus_2:
		
		# restore $s registers
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		addi $sp, $sp, 16
		
		li $v0, 3
		jr $ra
	
	merge_other_values:
	# Check if both tiles are >= 3.
	# We already accounted for both tiles = 1 or 2.
	li $t0, 3
	
	bge $s2, $t0, merge_tile_1_valid # tile 1 >= 3
	# if not, invalid.
	j merge_invalid_error
	
	merge_tile_1_valid:
		bge $s3, $t0, merge_tile_2_valid # tile 2 >= 3
		# if not, invalid.
		j merge_invalid_error
		
		merge_tile_2_valid:
			# Both tiles >= 3
			
			bne $s2, $s3, merge_invalid_error # if tile 1 != tile 2, invalid merge.
			# otherwise we add them and return. 
			add $t0, $s2, $s3
			move $v0, $t0
			
			# restore $s registers
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $s2, 8($sp)
			lw $s3, 12($sp)
			addi $sp, $sp, 16
			
			jr $ra
			
	# Invalid merges.
	merge_invalid_error:
		
		# restore $s registers
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		addi $sp, $sp, 16
		
		li $v0, -1
		jr $ra

# Part VI
slide_row:
	# $a0 has board
	# $a1 has the row to shift left or right
	# $a2 has thd shift direction ( -1 is left, 1 is right)
	
	
	# $s0 is "i"
	# $s1 is loop controller, # of columns
	# $s2 is j, to keep track of hitting end of loop
	# $s3 stores current tile
	# $s4 stores tile before current one
	# $s5 stores tile after current one
	# $s6 has the return value. Defaults to 0.
	
	# nested for loop ( i < len - 1 and j = i up to j < len)
	# shift left = look at current tile | if left is 0, move it | if left is not 0, look at right tile. if can merge, merge into current tile. shift everything to the right of that left, replace empty spots w/ 0's
	
	li $t0, 1 
	abs $t1, $a2 # store abs value of shift direction in $t1 ( 1 -> 1 and -1 -> 1)
	bne $t0, $t1, invalid_slide_direction
	
	lb $t1, 0($a0) # load number of rows
	bge $a1, $t1, invalid_slide_row # valid indices to shift is 0 -> len -1
	
	j valid_direction_and_row
	
	invalid_slide_direction:
	invalid_slide_row:
		li $v0, -1
		jr $ra
		
	valid_direction_and_row:
	li $t0, -1
	beq $a2, $t0, slide_row_left
	
	li $t0, 1
	beq $a2, $t0, slide_row_right
	# Slide left code
	slide_row_left:
	
	li $s0, 1 # $s0 is "i"
	lb $s1, 1($a0) # $s1 is len ( # of columns), loop controller.
	li $s2, 2 # start with i = 1, go until i + 1 = len ( use extra var j initialized to 2 and increment w/ i)
	li $s6, 0
	
	for_slide_row_left:
		bgt $s2, $s1, for_slide_row_left_done
		# look at current tile | if left is 0, move it | if left is not 0, look at right tile. if can merge, merge into current tile. shift everything to the right of that left, replace empty spots w/ 0's | if current is 0, continue.
		# i = current tile
		# i - 1 = previous tile
		# j = next tile
		
		# ***** LOAD CURRENT TILE *****
		
		# preserve args
		addi $sp, $sp, -16
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)
		sw $ra, 12($sp)
			
		# $a0 still has board
		# $a1 still has the row
		move $a2, $s0 # #a2 needs the column
		
		jal get_tile
		
		# restore args
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $ra, 12($sp)
		addi $sp, $sp, 16
		
		# $v0 has the tile value.
		move $s3, $v0
		beqz $s3, for_slide_row_left_zero_tile
		j for_slide_row_left_non_zero_tile
		
		for_slide_row_left_zero_tile:
			# increment and continue
			addi $s0, $s0, 1
			addi $s2, $s2, 1
			j for_slide_row_left
		
		for_slide_row_left_non_zero_tile:
		
		# ***** LOAD PREVIOUS TILE *****
		
		# preserve args
		addi $sp, $sp, -16
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)
		sw $ra, 12($sp)
			
		# $a0 still has board
		# $a1 still has the row
		move $a2, $s0 # #a2 needs the column
		addi $a2, $a2, -1 # look at previous column
		
		jal get_tile
		
		# restore args
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $ra, 12($sp)
		addi $sp, $sp, 16
		
		# $v0 has the tile value.
		move $s4, $v0
		
		# If previous tile is 0, shift current tile left and set current to 0. This will repeat next loop since the new previous will be 0.
		beqz $s4, for_slide_row_left_cascading_zeros
		
		# otherwise, we check if the value to the right is mergeable or not.
		j for_slide_row_left_check_merge
		
			for_slide_row_left_cascading_zeros:
			
			# ***** Set previous tile to current tile. *****
			
			# preserve args
			addi $sp, $sp, -16
			sw $a0, 0($sp)
			sw $a1, 4($sp)
			sw $a2, 8($sp)
			sw $ra, 12($sp)
		
			# $a0 still has board
			# $a1 has row 
			move $a2, $s0 
			addi $a2, $a2, -1 # $a2 needs previous column
			move $a3, $s3 # $a3 needs value to write ( value in current tile)
		
			jal set_tile
		
			# restore args
			lw $a0, 0($sp)
			lw $a1, 4($sp)
			lw $a2, 8($sp)
			lw $ra, 12($sp)
			addi $sp, $sp, 16
			
			# ***** set current tile to 0 *****
			# preserve args
			addi $sp, $sp, -16
			sw $a0, 0($sp)
			sw $a1, 4($sp)
			sw $a2, 8($sp)
			sw $ra, 12($sp)
		
			# $a0 still has board
			# $a1 has row 
			move $a2, $s0 # $a2 needs currents column
			li $a3, 0 # $a3 needs to write 0
		
			jal set_tile
		
			# restore args
			lw $a0, 0($sp)
			lw $a1, 4($sp)
			lw $a2, 8($sp)
			lw $ra, 12($sp)
			addi $sp, $sp, 16
			
			# Increment i and j and loop over.
			addi $s0, $s0, 1
			addi $s2, $s2, 1
			j for_slide_row_left
			
		for_slide_row_left_check_merge:
			# Check if value to the right is mergeable or not. If not, we just continue on. If so, we merge them.
			# Next column is stored in j, we can use that. ($s2)
			# ***** get value to the right of current *****
			
			# preserve args
			addi $sp, $sp, -16
			sw $a0, 0($sp)
			sw $a1, 4($sp)
			sw $a2, 8($sp)
			sw $ra, 12($sp)
			
			# $a0 still has board
			# $a1 still has the row
			move $a2, $s2 # #a2 needs the column
		
			jal get_tile
		
			# restore args
			lw $a0, 0($sp)
			lw $a1, 4($sp)
			lw $a2, 8($sp)
			lw $ra, 12($sp)
			addi $sp, $sp, 16
		
			# $v0 has the tile value.
			move $s5, $v0 # store next tile value in $s5
			
			# ***** check if current tile and next tile can be merged. *****
			
			# preserve args
			addi $sp, $sp, -16
			sw $a0, 0($sp)
			sw $a1, 4($sp)
			sw $a2, 8($sp)
			sw $ra, 12($sp)
			
			# $a0 still has board
			move $a1, $a1 # $a1 needs row of 1st tile (basically $a1)
			move $a2, $s0 # $a2 needs col of current tile ( i )
			
			move $a3, $a1 # $a3 needs row of 2nd tile (basically $a1)
			
			addi $sp, $sp, -4 # make space for additional arg
			sw $s2 ,0($sp)# 0($sp) needs col of next tile ( j )
			 
			 jal can_be_merged
			 
			 addi $sp, $sp, 4 # get rid of additional arg
			 # restore args
			lw $a0, 0($sp)
			lw $a1, 4($sp)
			lw $a2, 8($sp)
			lw $ra, 12($sp)
			addi $sp, $sp, 16
			
			# merge value stored in $v0
			bgtz $v0, for_slide_row_left_merge 
			
			# otherwise increment and continue
			addi $s0, $s0, 1
			addi $s2, $s2, 1
			j for_slide_row_left
			
			for_slide_row_left_merge:
			# merge the tiles. = set current tile to the merge value, set next tile to 0. The cascading zeroes will fill in the rest.
			# Update return value.
			li $s6, 1
			# ***** set current tile to merge value *****
			
			# preserve args
			addi $sp, $sp, -16
			sw $a0, 0($sp)
			sw $a1, 4($sp)
			sw $a2, 8($sp)
			sw $ra, 12($sp)
		
			# $a0 still has board
			# $a1 has row 
			move $a2, $s0 # $a2 needs current column
			move $a3, $v0 # $a3 will write the merge value.
		
			jal set_tile
		
			# restore args
			lw $a0, 0($sp)
			lw $a1, 4($sp)
			lw $a2, 8($sp)
			lw $ra, 12($sp)
			addi $sp, $sp, 16
			
			# ***** set next tile to 0 *****
			
			# preserve args
			addi $sp, $sp, -16
			sw $a0, 0($sp)
			sw $a1, 4($sp)
			sw $a2, 8($sp)
			sw $ra, 12($sp)
		
			# $a0 still has board
			# $a1 has row 
			move $a2, $s2 # $a2 needs to write to the next column, j.
			li $a3, 0 # $a3 needs to write 0
		
			jal set_tile
		
			# restore args
			lw $a0, 0($sp)
			lw $a1, 4($sp)
			lw $a2, 8($sp)
			lw $ra, 12($sp)
			addi $sp, $sp, 16
			
			# Increment and loop over.
			addi $s0, $s0, 1
			addi $s2, $s2, 1
			j for_slide_row_left
			
	for_slide_row_left_done:
	move $v0, $s6
	jr $ra
	
	# Slide right code
	slide_row_right:
		# Start from 2nd to last element ( element len - 2)
		
		lb $s0, 1($a0) # load # of columns ( len of the row)
		addi $s0, $s0, -2 # 2nd to last element
		li $s1, 0 # loop down to 0. 
		# start with i = 2nd to last elem, go until i - 1 = len 
		move $s2, $s0
		addi $s2, $s2, 1# ( use extra var j initialized to last elem and decrement alongside i)
		li $s6, 0 # return value
		
		for_slide_row_right:
			bltz $s0, for_slide_row_right_done
			# $s0 = current tile
			# $ s2 = next tile
			# $s0 - 1 = previous tile
			
			# look at current tile, if right is 0, shift it | if right is not 0, try to merge. if cannot merge, continue. if can merge, merge. replace everything to left w/ 0's. if current is 0, continue.
			
			# ***** LOAD CURRENT TILE *****
			
			# preserve args
			addi $sp, $sp, -16
			sw $a0, 0($sp)
			sw $a1, 4($sp)
			sw $a2, 8($sp)
			sw $ra, 12($sp)
			
			# $a0 still has board
			# $a1 still has the row
			move $a2, $s0 # #a2 needs the column
		
			jal get_tile
		
			# restore args
			lw $a0, 0($sp)
			lw $a1, 4($sp)
			lw $a2, 8($sp)
			lw $ra, 12($sp)
			addi $sp, $sp, 16
		
			# $v0 has the tile value.
			
			move $s3, $v0
			beqz $s3, for_slide_row_right_zero_tile
			j for_slide_row_right_non_zero_tile
		
			for_slide_row_right_zero_tile:
				# decrement and continue
				addi $s0, $s0, -1
				addi $s2, $s2, -1
				j for_slide_row_right
		
			for_slide_row_right_non_zero_tile:
			
			# ***** LOAD NEXT TILE *****
			
			# preserve args
			addi $sp, $sp, -16
			sw $a0, 0($sp)
			sw $a1, 4($sp)
			sw $a2, 8($sp)
			sw $ra, 12($sp)
			
			# $a0 still has board
			# $a1 still has the row
			move $a2, $s0 # #a2 needs the column
			move $a2, $s2 # look at next column ( j) 
		
			jal get_tile
		
			# restore args
			lw $a0, 0($sp)
			lw $a1, 4($sp)
			lw $a2, 8($sp)
			lw $ra, 12($sp)
			addi $sp, $sp, 16
		
			# $v0 has the tile value.
			move $s5, $v0
			
			# If next tile is 0, shift current tile right and set current to 0. This will repeat next loop since the new next will be 0.
			beqz $s5, for_slide_row_right_cascading_zeros
		
			# otherwise, we check if the value to the right is mergeable or not.
			j for_slide_row_right_check_merge
			
			for_slide_row_right_cascading_zeros:
			
				# ***** Set next tile to current tile. *****
			
				# preserve args
				addi $sp, $sp, -16
				sw $a0, 0($sp)
				sw $a1, 4($sp)
				sw $a2, 8($sp)
				sw $ra, 12($sp)
		
				# $a0 still has board
				# $a1 has row 
				move $a2, $s0 
				move $a2, $s2 # $a2 needs next column ( $s2 = j )
				move $a3, $s3 # $a3 needs value to write ( value in current tile)
		
				jal set_tile
		
				# restore args
				lw $a0, 0($sp)
				lw $a1, 4($sp)
				lw $a2, 8($sp)
				lw $ra, 12($sp)
				addi $sp, $sp, 16
			
				# ***** set current tile to 0 *****
				
				# preserve args
				addi $sp, $sp, -16
				sw $a0, 0($sp)
				sw $a1, 4($sp)
				sw $a2, 8($sp)
				sw $ra, 12($sp)
		
				# $a0 still has board
				# $a1 has row 
				move $a2, $s0 # $a2 needs currents column
				li $a3, 0 # $a3 needs to write 0
		
				jal set_tile
		
				# restore args
				lw $a0, 0($sp)
				lw $a1, 4($sp)
				lw $a2, 8($sp)
				lw $ra, 12($sp)
				addi $sp, $sp, 16
			
				# Decrement i and j and loop over.
				addi $s0, $s0, -1
				addi $s2, $s2, -1
				j for_slide_row_right
				
			for_slide_row_right_check_merge:
				# Check if value to the right is mergeable or not. If not, we just continue on. If so, we merge them.
				# Next column is stored in j, we can use that. ($s2)
			
				# ***** get value to the right of current *****
				# preserve args
				addi $sp, $sp, -16
				sw $a0, 0($sp)
				sw $a1, 4($sp)
				sw $a2, 8($sp)
				sw $ra, 12($sp)
			
				# $a0 still has board
				# $a1 still has the row
				move $a2, $s2 # #a2 needs the column
		
				jal get_tile
		
				# restore args
				lw $a0, 0($sp)
				lw $a1, 4($sp)
				lw $a2, 8($sp)
				lw $ra, 12($sp)
				addi $sp, $sp, 16
		
				# $v0 has the tile value.
				move $s5, $v0 # store next tile value in $s5
				
				# ***** check if current tile and next tile can be merged. *****
			
				# preserve args
				addi $sp, $sp, -16
				sw $a0, 0($sp)
				sw $a1, 4($sp)
				sw $a2, 8($sp)
				sw $ra, 12($sp)
			
				# $a0 still has board
				move $a1, $a1 # $a1 needs row of 1st tile (basically $a1)
				move $a2, $s0 # $a2 needs col of current tile ( i )
			
				move $a3, $a1 # $a3 needs row of 2nd tile (basically $a1)
			
				addi $sp, $sp, -4 # make space for additional arg
				sw $s2 ,0($sp)# 0($sp) needs col of next tile ( j )
			 
				 jal can_be_merged
			 
			 	addi $sp, $sp, 4 # get rid of additional arg
			 	# restore args
				lw $a0, 0($sp)
				lw $a1, 4($sp)
				lw $a2, 8($sp)
				lw $ra, 12($sp)
				addi $sp, $sp, 16
			
				# merge value stored in $v0
				bgtz $v0, for_slide_row_right_merge
				
				# otherwise decrement and continue
				addi $s0, $s0, -1
				addi $s2, $s2, -1
				j for_slide_row_right
				
				for_slide_row_right_merge:
				
					# merge the tiles. = set next tile to the merge value, set current tile to 0. The cascading zeroes will fill in the rest.
					# Update return value.
					li $s6, 1
				
					# ***** Set next tile to merge value *****
				
					# preserve args
					addi $sp, $sp, -16
					sw $a0, 0($sp)
					sw $a1, 4($sp)
					sw $a2, 8($sp)
					sw $ra, 12($sp)
		
					# $a0 still has board
					# $a1 has row 
					move $a2, $s2 # $a2 needs next column
					move $a3, $v0 # $a3 will write the merge value.
		
					jal set_tile
		
					# restore args
					lw $a0, 0($sp)
					lw $a1, 4($sp)
					lw $a2, 8($sp)
					lw $ra, 12($sp)
					addi $sp, $sp, 16
					
					# ***** set current tile to 0 *****
					
					# preserve args
					addi $sp, $sp, -16
					sw $a0, 0($sp)
					sw $a1, 4($sp)
					sw $a2, 8($sp)
					sw $ra, 12($sp)
		
					# $a0 still has board
					# $a1 has row
					move $a2, $s0 # $ a2 needs current column
					li $a3, 0 # $a3 needs to write 0
					
					jal set_tile
					
					# restore args
					lw $a0, 0($sp)
					lw $a1, 4($sp)
					lw $a2, 8($sp)
					lw $ra, 12($sp)
					addi $sp, $sp, 16
					
					# Decrement and loop over.
					addi $s0, $s0, -1
					addi $s2, $s2, -1
					j for_slide_row_right
	for_slide_row_right_done:
	move $v0, $s6
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
