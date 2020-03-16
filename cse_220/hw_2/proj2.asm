# Tim Wu
# TIMWU
# 112550028

.text
strlen:
    	# Arg stored in $a0
    	li $t1, 0 # Running sum for len
    
    	while_strlen:
    	
    		lbu $t0, 0($a0)
    		beqz $t0, while_strlen_done # If the loaded char is 0 = null terminator
    	
		addi $t1, $t1, 1 # Increment running sum
		addi $a0, $a0, 1 # Look at next char
	
    		j while_strlen
    	
   	while_strlen_done:
    
   	move $v0, $t1 # Move return value into $v0
   	jr $ra # Return to caller

insert:
	# $a0 contains str
	# $a1 contains the char to insert
	# $a2 contains the insertion index
	
	addi $sp, $sp, -16
	sw $ra, 0($sp) # Calling a leaf function
	sw $a0, 4($sp) # Preserve args, caller's responsibility
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	jal strlen
	
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	addi $sp, $sp, 16
	
	ble $a2, $v0, valid_insertion_index # If insertion index <= strlen, we have a valid index to insert at.
	
	li $t0, -1 # Invalid index, return -1
	move $v0, $t0
	jr $ra
	
	valid_insertion_index:
	move $t0, $v0 # Store the length of the str in $t0
	
	# loop backwards from end of string, shifting to the right - once we hit the target index we put the given char in that spot.
	
	move $t1, $t0 # "i" in for loop = strlen
	add $a0, $a0, $t0 # Add len of str to str address, going backwards
	
	for_insertion:
		bltz, $t1, for_insertion_done
		
		lbu $t2, 0($a0) # Load current char
		sb $t2, 1($a0) # Shift char 1 byte right
		
		beq $t1, $a2, index_found # Found the index to insert at
		
		addi $a0, $a0, -1 # Index not found, keep looking.
		addi $t1, $t1, -1 # Decrement "i"
		
		j for_insertion
		
		index_found:
			sb $a1, 0($a0)
			j for_insertion_done
		
	for_insertion_done:
	
	addi $t0, $t0, 1 # Incremented length
	move $v0, $t0 # Store len + 1 into $v0 to return
	jr $ra

pacman:
	# String to eat is in $a0
	
	# $s0 is unchanged
	# s1-5 are for G, H, O, S, T & their respective lowercase forms.
	# s6 is the for-loop controller "i"
	# s7 is the for-loop's upper bound
	
	addi $sp, $sp, -28 # Store $s values we're going to be using in the function 

	sw $s1, 0($sp)
	sw $s2, 4($sp)
	sw $s3, 8($sp)
	sw $s4, 12($sp)
	sw $s5, 16($sp)
	sw $s6, 20($sp)
	sw $s7, 24($sp)
	
	li $s1, 71 # "G" in ascii
	li $s2, 72 # "H"
	li $s3, 79 # "O"
	li $s4, 83 # "S"
	li $s5, 84 # "T"
	
	addi $sp, $sp, -8
	sw $ra, 0($sp) # Calling a leaf function
	sw $a0, 4($sp) # Preserve args, caller's responsibility
	
	# $a0 still the string
	li $a1, 60 # 60 is "<" in ascii
	li $a2, 0 # Insert at index 0
	jal insert
	
	lw $ra, 0($sp) # Restore args
	lw $a0, 4($sp)
	addi $sp, $sp, 8
	
	# insert function returned string length in $v0.
	li $s6, 0  #"i" in for-loop
	move $s7, $v0 # Upper bound in for-loop

	move $t2, $a0 # Store original address of the string
	addi $a0, $a0, 1 # Pacman already at index 0, we wanna look at the next char.
	
	for_pacman: # Loop from 0 to strlen 
		beq $s6, $s7, for_pacman_done
		
		lbu $t0, 0($a0)
		beqz $t0, for_pacman_done
		
		# Check for G, H, O, S, T
		beq $t0, $s1, has_ghost
		beq $t0, $s2, has_ghost
		beq $t0, $s3, has_ghost
		beq $t0, $s4, has_ghost
		beq $t0, $s5, has_ghost
		
		# Check for g, h, o, s, t
		addi $s1, $s1, 32 # Uppercase & lowercase offset in ascii is 32.
		addi $s2, $s2, 32 
		addi $s3, $s3, 32 
		addi $s4, $s4, 32 
		addi $s5, $s5, 32 
		beq $t0, $s1, has_ghost
		beq $t0, $s2, has_ghost
		beq $t0, $s3, has_ghost
		beq $t0, $s4, has_ghost
		beq $t0, $s5, has_ghost
		
		addi $s1, $s1, -32 # Undo offset
		addi $s2, $s2, -32 
		addi $s3, $s3, -32 
		addi $s4, $s4, -32 
		addi $s5, $s5, -32
		
		# Character is eatable, set previous char to underscore and insert pacman in the current index
		
		li $t1, 95 # underscore
		sb $t1, -1($a0)
		
		li $t3, 60
		sb $t3, 0($a0)
		
		addi $s6, $s6, 1
		addi $a0, $a0, 1
		
		j for_pacman
		
	for_pacman_done:
	j return_pacman
	
	has_ghost:
		beqz $s6, return_pacman # Only need to worry about following if he was stopped in the middle of eating, if he was stopped at index 0, we just return strlen + 1
		
		# shift entire string left to align back in original address, get rid of leading underscore

		move $a0, $t2 # Restore string address
		li $t3, 0 # "i" in loop
		for_ghost_shift:
			beq $t3, $s7, ghost_shift_done
			
			lbu $t1, 1($a0) # Shift next char to current pos
			beqz $t5, ghost_shift_done
			sb $t1, 0($a0)
			
			addi $a0, $a0, 1
			addi $t3, $t3, 1
			j for_ghost_shift
		
		ghost_shift_done:
		
		addi $s6, $s6, -1 # Pacman index
		j return_pacman_ghost
	
	return_pacman:
	move $a0, $t2
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a0, 4($sp) # Store current address in case callee changes it
	
	jal strlen
	
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	addi $sp, $sp, 8
	
	move $v1, $v0  # Store current length in 2nd return value
	move $v0, $s6 # Store pacman's location
	# Restore s registers
	lw $s1, 0($sp)
	lw $s2, 4($sp)
	lw $s3, 8($sp)
	lw $s4, 12($sp)
	lw $s5, 16($sp)
	lw $s6, 20($sp)
	lw $s7, 24($sp)
	
	addi $sp, $sp, 28
	addi $a0, $a0, 1
	
	jr $ra
	
	return_pacman_ghost:
	move $a0, $t2
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a0, 4($sp) # Store current address in case callee changes it
	
	jal strlen
	
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	addi $sp, $sp, 8
	addi $v0, $v0, -1
	move $v1, $v0  # Store current length in 2nd return value
	move $v0, $s6 # Store pacman's location
	# Restore s registers
	lw $s1, 0($sp)
	lw $s2, 4($sp)
	lw $s3, 8($sp)
	lw $s4, 12($sp)
	lw $s5, 16($sp)
	lw $s6, 20($sp)
	lw $s7, 24($sp)
	
	addi $sp, $sp, 28
	addi $a0, $a0, 1
	
	jr $ra
	
replace_first_pair:
	# $a0 is str
	# $a1 is first char of byte-pair
	# $a2 is 2nd char of byte-pair
	# $a3 is what will replace the byte-pair
	# 0($sp) is the starting index
	
	addi $sp, $sp, -20 # Save args to call strlen
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	sw $a3, 16($sp)
	
	jal strlen
	
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	addi $sp, $sp, 20
	
	move $t1, $v0 # Store string's length in $t1
	
	lw $t0, 0($sp) # Load starting index
	add $a0, $a0, $t0
	
	# $t0 is index to start looking at, "i" in for-loop 
	# Upper-bound is $t1 (string length)
	
	for_replace_first_pair:
		bge $t0, $t1, pair_not_found
		addi $t0, $t0, 1 # Increment for-loop
		
		lbu $t2, 0($a0) # Load 1st char
		lbu $t3, 1($a0) # Load 2nd char
		
		addi $a0, $a0, 1 # Look at next two (including the 2nd of the current pair we're looking at)
		
		bne $t2, $a1, for_replace_first_pair # 1st char != 1st target char, this pair is no good
		bne $t3, $a2, for_replace_first_pair # 2nd char != 2nd target char
		
		sb $a3, -1($a0) # Store given char in left spot, use -1 because already incremented earlier


		# Shift everything else 1 index left.
		
		move $t4, $t0 # copy $t0, we need to return it later.
		
		# we can re-use the upperbound of $t1
		for_replace_first_pair_shift:
			beq $t4, $t1, for_replace_first_pair_shift_done
			addi $t4, $t4, 1
			
			lbu $t2, 1($a0) # Load next char
			sb $t2, 0($a0) # Replace current char w/ next char
			
			addi $a0, $a0, 1 # Look at next char
			j for_replace_first_pair_shift
			
		for_replace_first_pair_shift_done:
		j pair_found
	
	pair_found:
	move $v0, $t0 # Store current index of for-loop in return register
	addi $v0, $v0, -1 # Need to offset because of index-1 based counting
	jr $ra
	
	pair_not_found:
	li $v0, -1 
	jr $ra

replace_all_pairs:
	# $a0 has the str
	# $a1 has first of byte-pair
	# a2 has second
	# a3 has the replacement char
	
	# We're using $s0 to count the number of replacements | $s1 as "i" in our for loop | $s2 as strlen (upperbound for loop) | $s3 has string | $s4 has first char of byte-pair | $s5 has second | $s6 has replacement char
	addi $sp, $sp, -28
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	
	# Move args into $s registers
	move $s3, $a0
	move $s4, $a1
	move $s5, $a2
	move $s6, $a3
	
	addi $sp, $sp, -4 # Store $ra, already put $a into $s var so don't care what callee does to them
	sw $ra, 0($sp) 
	
	jal strlen
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	li $s0, 0 # Initialize running sum to 0
	li $s1, 0 # Initialize "i" to 0
	move $s2, $v0 # Store str len in $s2
	
	for_replace_all_byte_pairs:
		beq $s1, $s2, for_replace_all_byte_pairs_done
		
		move $a0, $s3 # Move string into a0
		move $a1, $s4 # Move first byte
		move $a2, $s5 # second byte
		move $a3, $s6 # replacement char
		
		addi $sp, $sp, -8
		sw $s1, 0($sp) # Store additional arg of index in stack
		sw $ra, 4($sp)
		
		jal replace_first_pair
		
		lw $ra, 4($sp)
		addi $sp, $sp, 8
		
		bltz $v0, no_replacement_made
		
		move $s1, $v0 # Jump to replaced char
		addi $s0, $s0, 1 # Replacement made
		
		no_replacement_made:
		addi $s1, $s1, 1 # Look at next char
		j for_replace_all_byte_pairs
	
	for_replace_all_byte_pairs_done:
	
	move $v0, $s0 # Move running sum into return register
	
	lw $s0, 0($sp) # Restore $s registers
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	addi $sp, $sp, 28
	
	jr $ra

bytepair_encode:
	# $a0 has str
	# $a1 has frequencies NOT GRADED
	# $a2 has replacements GRADED
	
	addi $sp, $sp, -28 # Preserve $s registers we're gonna use
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	
	# Zero out replacements
	li $t0, 0
	li $t1, 52
	move $t2, $a2 # Store copy of array address, we'll manipulate $t2.

	for_zeroing_encoding:
		beq $t0, $t1, for_zeroing_encoding_done
		addi $t0, $t0, 1
		
		li $t5, 0
		sb $t5, 0($t2) # Store 0 in current byte
		addi $t2, $t2, 1# Look at next char
		
		j for_zeroing_encoding
		
	for_zeroing_encoding_done:

	# Zero out frequencies
	# we're offered 26^2 bytes (676) of space.
	li $t0, 0
	li $t1, 676
	move $t2, $a1 
	
	for_zeroing_encoding2:
		beq $t0, $t1, for_zeroing_encoding2_done
		addi $t0, $t0, 1

		sb $0, 0($t2)
		addi $t2, $t2, 1
		
		j for_zeroing_encoding2
	
	for_zeroing_encoding2_done:
	li $s0, 0 # Each encoding will make 26 replacements at most.
	li $s4, 90 # "Z" in ascii. Decrement every time we make a replacement. 
	li $s5, 25 # "Z" is capital letter 25. Using this for frequencies array.
	get_frequencies:
	
	addi $sp, $sp, -16 # Store args to get string length
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $ra, 12($sp)
	
	jal strlen
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	
	move $s1, $v0 # Store strlen in $s1
	addi $s1, $s1, -1 # We want to loop from 0 to len - 1
	move $t0, $a0 # Easier to manipulate pointer to str
	move $t3, $a1 # Manipulate ptr to frequencies
	
	li $s2, 0 # "i" in for-loop
	# $s1 has upper-bound, strlen
	li $s3, 90 # "Z" in ascii, used to check whether current char is uppercase or not.
	li $s6, 0 # Number of times we find adjacent lowercase char, used to control the return value and prevent redundant loops
	for_get_encoding_frequencies:
		beq $s2, $s1, for_get_encoding_frequencies_done
		
		lbu $t1, 0($t0) # Load first char in pair
		lbu $t2, 1($t0) # Load 2nd char in pair
		addi $t0, $t0, 1 # Look at next pair
		addi $s2, $s2, 1
	
		ble $t1, $s3, for_get_encoding_frequencies # If any of this pair is uppercase, we need to look at the next pair
		ble $t2, $s3, for_get_encoding_frequencies
		
		# Both are lowercase
		addi $s6, $s6, 1
		move $t5, $a1 # Loop through frequencies, see if we've seen this pair before.
		while_encoding_check_existing_frequencies:
			lbu $t6, 0($t5)
			lbu $t7, 1($t5)
			
			# Nothing found, create new frequency entry
			beqz $t6, while_encoding_check_existing_frequencies_done # Hit a null terminator, this is a new pair.
			beqz $t7, while_encoding_check_existing_frequencies_done
			
			 bne $t6, $t1, no_match # First char of pair doesn't match
			 bne $t7, $t2, no_match # 2nd char of pair doesn't match, no way it can be the correct one, keep looking. 
			 
			 # Correct pair

			 lbu $t4 2($t5) # Increment frequency of this pair
			 addi $t4, $t4, 1
			 sb $t4, 2($t5)
			 j for_get_encoding_frequencies # Look at next pair
			 
			 # Wrong pair
			 no_match: 
			 	addi $t5, $t5, 3
			 	j while_encoding_check_existing_frequencies
			 	 
			 end_of_frequencies:
			 	
		while_encoding_check_existing_frequencies_done:

		 # Create new frequency
		 
		sb $t1, 0($t3) 
		sb $t2, 1($t3)
		
		lbu $t4 2($t3) # Increment frequency of this pair
		addi $t4, $t4, 1
		sb $t4, 2($t3)
		
		addi $t3, $t3, 3
		
		j for_get_encoding_frequencies
	
	for_get_encoding_frequencies_done:
	# Find largest frequency, replace w/ it, zero out frequencies (keep the pairs but just zero the count (every 3 bytes), jump to get_frequencies
	
	# t0 has max frequency value
	# t1 has the address of the max frequency byte pair
	# $t2 is the current address of the bytepair we're looking at
	# $t3 is a temp var to load the current pair frequency we're looking at.
	
	move $t2, $a1 # Manipulate ptr to frequencies
	
	li $t0, 0 # $t0 is a variable holding the max frequency
	li $t1, 0 # $t1 is a variable holding the address of the byte-pair w/ the max frequency
	
	get_largest_frequency:
		lbu $t3, 2($t2) # Load current frequency
		beqz $t3, get_largest_frequency_done
		
		addi $t2, $t2, 3 # Look at next pair
		beq $t3, $t0, frequency_tie
		blt $t3, $t0, get_largest_frequency # If current freq lower than max, ignore it
		
		# current freq greater than max
		j no_frequency_tie
		frequency_tie:
			lbu $t6, -3($t2) # Current
			lbu $t7, -3($t1) # max
			
			beq $t6, $t7, two_way_frequency_tie
			blt $t6, $t7, new_max_from_tie # current comes first alphabetically
			j get_largest_frequency # max comes first alphabetically
			
			two_way_frequency_tie:
				lbu $t6, -2($t2) # Current
				lbu $t7, -2($t1) # max
				
				blt $t6, $t7, new_max_from_tie # current comes first alphabetically
				j get_largest_frequency # max comes first alphabetically
			
		new_max_from_tie:
		no_frequency_tie:
		# Current freq larger, new max found either through a tiebreaker or no tie.
		
		move $t0, $t3 # Replace max value
		move $t1, $t2  # Replace max address
		j get_largest_frequency
		
	get_largest_frequency_done:
	beqz $s6, string_encoded # Last run through yielded 0 pairs of adjacent lowercase characters, we're done. 
	# $t1 has the address of the highest freq byte-pair
	lbu $t4, -3($t1) # 1st char of byte-pair
	lbu $t5, -2($t1) # 2nd char of byte-pair
	
	move $t2, $a2 # Make $t2 a pointer to replacements array
	
	# Update replacements array
	# $t4 has 1st char
	# $t5 has 2nd char
	li $t0, 2
	mult $s5, $t0 # Find corresponding index for the byte-pair ( $s5 = i )
	mflo $t1 # Store 2 * i in $t1 (index for 1st byte)
	
	add $t2, $t2, $t1 # Index of 1st byte
	sb $t4, 0($t2)
	addi $t2, $t2, 1 # Index of 2nd byte
	sb $t5, 0($t2)
	
	
	# Store args to call replace_all_pairs
	addi $sp, $sp, -16 
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $ra, 12($sp)

	# 1st char of byte-pair
	move $a1, $t4
	
	# 2nd char of byte-pair
	move $a2, $t5
	
	move $a3, $s4 # Current replacement char
	
	jal replace_all_pairs
	add $s0, $s0, $v0 # Add # of replacements made
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	
	# Update replacement chars
	
	addi $s4, $s4, -1 # Previous uppercase char in alphabet.
	addi $s5, $s5, -1 # Aforementioned char's index in the alphabet.
	
	# zero out frequencies
	move $t0, $a1 # Pointer to frequencies
	
	li $t1, 0
	li $t2, 676
	zero_replacement_count:
		lbu $t3, 0($t0)
		beqz $t3, zero_replacement_count_done
		beq $t1, $t2, zero_replacement_count_done

		sb $0, 0($t0)
		addi $t0, $t0, 1
		j zero_replacement_count
		
	zero_replacement_count_done:
	# jump to get_frequencies
	
	li $t0, 26
	beq $s0, $t0, string_encoded # 26 replacements made.
	j get_frequencies
	
	string_encoded:
	move $v0, $s0
	
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	addi $sp, $sp, 28 # Restore registers
	
	jr $ra

replace_first_char:
	# $a0 has str
	# $a1 has the char to replace
	# $a2 has 1st of byte-pair
	# $a3 has 2nd of byte-pair
	# 0($sp) is the start index
	
	move $fp, $sp # Set fp equal to sp so we can access the additional args
	
	addi $sp, $sp, -8 # Preserve $s regs we're using
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	
	addi $sp, $sp, -20 # Save args to call strlen
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	sw $a3, 16($sp)
	
	jal strlen
	
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	addi $sp, $sp, 20
	
	move $t1, $v0 # Store string's length in $t1
	
	lw $t0, 0($fp) # Load starting index from fp
	move $s1, $a0 # Use $s1 as a pointer to str
	
	add $s1, $s1, $t0
	# $t0 is index to start looking at, "i" in for-loop 
	# Upper-bound is $t1 (string length)
	
	for_replace_first_char:
		bge $t0, $t1, char_not_found
		addi $t0, $t0, 1
		
		lbu $t2, 0($s1) # Load current char
		addi $s1, $s1, 1 # Look at nexr char
		
		bne $t2, $a1, for_replace_first_char # Current char not what we're looking for, loop back around.

		# Char found
		# Replace current index with 1st char of bytepair ( need to use -1 because already incremented)
		sb $a2, -1($s1)
		
		move $s0, $t0 # Preserve index, our responsibility b/c this is the return value.
			
		# Insert 2nd char into current index, this'll shift the 1st char of the bytepair to the left. 
		addi $sp, $sp, -20 # Save args to call strlen
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		sw $a2, 12($sp)
		sw $a3, 16($sp)
		
		# Str is still $a0
		move $a1, $a3 # Store 2nd char of byte-pair as arg for insert
		move $a2, $t0 # Index to insert is t0
		jal insert
	
		lw $ra, 0($sp)
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		lw $a2, 12($sp)
		lw $a3, 16($sp)
		addi $sp, $sp, 20
		
		j char_found
	
	char_found:
	move $v0, $s0 
	addi $v0, $v0, -1 # Decrement because of index-1 based counting
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	addi $sp, $sp, 8 # Restore $s registers
	move $sp, $fp # Restore sp
	
	jr $ra
	
	char_not_found:
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	addi $sp, $sp, 8 # Restore $s registers
	move $sp, $fp # Restore sp
	
	li $v0, -1
	jr $ra

replace_all_chars:
	# $a0 has str
	# $a1 has char
	# $a2 has first of bytepair
	# $a3 has 2nd of bytepair
	
	# Preserve $s registers we're using
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	
	addi $sp, $sp, -20 # Preserve args for call to strlen
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $a3, 12($sp)
	sw $ra, 16($sp)
	
	jal strlen
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a3, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
	
	li $s0, 0 # "i" in for-loop
	move $s1, $v0 # Store strlen in $s1
	li $s2, 0 # Running sum for number of chars replaced
	move $s3, $a0 # Use $s3 as pointer for str
	li $t5, 0 # Inital search index is 0. 
	for_replace_all_chars:
		beq $s0, $s1, for_replace_all_chars_done
		bgt $t5, $s1, for_replace_all_chars_done
		
		lbu $t0,  0($s3) # Load current char
		beqz $t0, for_replace_all_chars_done # If current char is null terminator, end it.
		
		addi $s3, $s3, 1 # Look at next char in str
		addi $s0, $s0, 1 # Increment for-loop
		
		# call replace_first_char
		addi $s2, $s2, 1 # Replacement being made.

		addi $sp, $sp, -20 # Preserve args for call to replace_first_char
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)
		sw $a3, 12($sp)
		sw $ra, 16($sp)
		# $a0 still has str
		# $a1 still has char
		# $a2 still has 1st
		# $a3 still has 2nd
		
		# Need to push start_index onto stack
		addi $sp, $sp, -4
		sw $t5, 0($sp)
		
		jal replace_first_char
		
		addi $sp, $sp, 4 # Dispose of that arg, we don't need it anymore.
		
		move $t5, $v0 # Store the return index in $t5 to reuse.
		
		lw $a0, 0($sp) # Restore args
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $a3, 12($sp)
		lw $ra, 16($sp)
		addi $sp, $sp, 20
		
		bltz $t5, replacement_neg_return # Neg return value means we need to end the loop early. Nothing else to replace.
		
		addi $t5, $t5, 2 # Look 2 indices ahead to account for the bytepair insertion.
		addi $s3, $s3, 1 # Look at next char in str
		addi $s1, $s1, 1 # Strlen increased, we need to increment it.
		j replacement_non_neg_return
		
		replacement_neg_return:
			addi $s2, $s2, -1 # Undo increment because we didn't replace anything.
			j for_replace_all_chars_done
			
		replacement_non_neg_return:
			j for_replace_all_chars
		
	for_replace_all_chars_done:
	
	move $v0, $s2
	
	# Restore $s registers
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16
	
	jr $ra

bytepair_decode:
	
	# $a0 has str
	# $a1 has replacements
	
	li $s0, 90 # "Z" in ascii
	li $s1, 51 # Last index of replacements (2nd char in bytepair). Subtract 1 to get the 1st char
	# Using $s2 as array pointer
	li $s3, 0 # Running sum of # of replacements made
	
	while_has_replacement:
		move $s2, $a1 # Use $s2 as pointer to replacements to manipulate, want to keep resetting for the loop.
		add $s2, $s2, $s1 # Move to index of 2nd char in byte-pair
		
		lbu $t0, 0($s2) # Load 2nd char of byte-pair
		beqz $t0, while_has_replacement_done # No more replacements.
		
		# Replacement to make.
		lbu $t1, -1($s2) # Load 1st char of byte-pair
		
		addi $sp, $sp, -12 # Preserve temp var to call replace_all_chars
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $ra, 8($sp)
		
		# $a0 still has str
		move $a1, $s0 # Move char to replace
		move $a2, $t1 # $t1 has 2nd char
		move $a3, $t0 # $t0 has 1st char
		
		jal replace_all_chars
		
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $ra, 8($sp)
		addi $sp, $sp, 12
		
		add $s3, $s3, $v0 # Increment # of replacements made
		addi $s0, $s0, -1 # Look at previous char in alphabet
		addi $s1, $s1, -2 # look at previous byte-pair in replacements
		
		j while_has_replacement
	
	while_has_replacement_done:
	
	move $v0, $s3
	jr $ra
