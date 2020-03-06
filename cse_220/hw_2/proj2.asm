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
	
	addi $sp, $sp, -12
	sw $ra, 0($sp) # Calling a leaf function
	sw $a0, 4($sp) # Preserve args, caller's responsibility
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	jal strlen
	
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	addi $sp, $sp, 12
	
	ble $a2, $v0, valid_insertion_index # If insertion index <= strlen, we have a valid index to insert at.
	
	li $t0, -1 # Invalid index, return -1
	move $v0, $t0
	jr $ra
	
	valid_insertion_index:
	move $t0, $v0 # Store the length of the str in $t0
	
	addi $t0, $t0, 1 # Valid insertion index, we can increment the length ahead of the actual insertion.
	
	# Use the stack to insert the given character into the string.
	# loop from i to strlen, when you find i = index, save it, start inner loop from j to strlen to shift everything 1 byte right (make sure to get null terminator, use <= prob), then after shifted, go back and replace that byte with new char
	
	move $v0, $t0 # Store len + 1 into $v0 to return
	jr $ra

pacman:
	jr $ra

replace_first_pair:
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
