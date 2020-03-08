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
	
	li $s0, 0 # Pac-man's ending position is 0 by default
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
			sb $t1, 0($a0)
			
			addi $a0, $a0, 1
			addi $t3, $t3, 1
			j for_ghost_shift
		
		ghost_shift_done:
		
		addi $s6, $s6, -1 # Pacman index
	
	
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
		beq $t0, $t1, pair_not_found
		addi $t0, $t0, 1 # Increment for-loop
		
		lbu $t2, 0($a0) # Load 1st char
		lbu $t3, 1($a0) # Load 2nd char
		
		addi $a0, $a0, 1 # Look at next two (including the 2nd of the current pair we're looking at)
		
		bne $t2, $a1, for_replace_first_pair # 1st char != 1st target char, this pair is no good
		bne $t3, $a2, for_replace_first_pair # 2nd char != 2nd target char
		
		sb $a3, -1($a0) # Store given char in left spot, use -1 because already incremented earlier


		# Shift everything else 1 index left.
		
		#addi $a0, $a0, 1 # Look at everything to the right of the replaced char
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
	jr $ra

bytepair_encode:
    jr $ra

replace_first_char:
    jr $ra

replace_all_chars:
    jr $ra

bytepair_decode:
    jr $ra
