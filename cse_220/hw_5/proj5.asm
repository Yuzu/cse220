# Tim Wu
# TIMWU
# 112550028

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################

.text

# Part 1
init_list:
	# $a0 has ptr to 8-byte block of uninitialized memory
	sw $0, 0($a0) # set size to 0
	sw $0, 4($a0) # set head address to 0
	jr $ra


# Part 2
append:
	
	# $a0 has list
	# $a1 has integer.
	
	# allocate 8 bytes for new node
	
	# preserve $a0 arg
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	li $v0, 9
	li $a0, 8
	syscall
	
	# restore $a0 arg
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	# new mem buffer stored in $v0.
	sw $a1, 0($v0) # store given int value in node's num value
	sw $0, 4($v0) # store null terminator in the node's next field
	
	lw $t0, 0($a0) # load list size
	addi $t0, $t0, 1 
	sw $t0, 0($a0) # store incremented size
	
	lw $t0, 4($a0) # load head address
	
	beqz $t0, append_empty # if head address is 0, then the list is currently empty so this node is the new head.
	j for_append
	
	append_empty:
		sw $v0, 4($a0) # store address of node as the head.
		lw $v0, 0($a0) # load list size
		jr $ra
	
	
	lw $t0, 4($a0) # load head address into $t0
	for_append:
		# keep going through nodes until we hit the null terminator
		
		lw $t1, 4($t0) # load address of next node in $t1
		beqz $t1, for_append_end_of_list # we've hit the last node, now to append. 
		
		# otherwise we look at the next node and move on.
		move $t0, $t1
		j for_append
		
		for_append_end_of_list:
			sw $v0, 4($t0) # store address of node to append in current node's next field.
			j for_append_done
	
	for_append_done:
	lw $v0, 0($a0) # load list size
	jr $ra


# Part 3
insert:
	# $a0 has list
	# $a1 has integer of new node
	# $a2 has index to insert at
	
	# check index.
	
	lw $t0, 0($a0) # load list size.
	
	bltz $a2, insert_invalid_index
	bgt $a2, $t0, insert_invalid_index
	j insert_valid_index
	
	insert_invalid_index:
		li $v0, -1
		jr $ra
		
	insert_valid_index:
	
	# if we're inserting into an empty list or at the last spot, we can just call append.
	beqz $t0, insert_call_append # if the list size is 0, the only valid insertion index is 0. no need to check that.
	beq $a2, $t0, insert_call_append # if the insertion index = the list size, we're appending to the end.
	j insert_middle # otherwise we're inserting somewhere in the middle of the list.
	
	insert_call_append:
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		
		# list still in $a0
		# $a1 still has integer.
		
		jal append
		
		lw $ra, 0($sp) 
		addi $sp, $sp, 4
		
		jr $ra
		
	insert_middle:
	# allocate 8 bytes for new node
	
	# preserve $a0 arg
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	li $v0, 9
	li $a0, 8
	syscall
	
	# restore $a0 arg
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	# new mem buffer stored in $v0.
	sw $a1, 0($v0) # store given int value in node's num value
	sw $0, 4($v0) # store null terminator in the node's next field
	
	# $t0 still has the list size.
	li $t1, 1 # $t1 keeps track of the index + 1 since we wanna insert before the index to shift the elem currently there right.
	lw $t2, 4($a0) # load head address into $t2
	
	for_insert:
		bge $t1, $t0, for_insert_done 
		
		# address of current node in $t2
		lw $t3, 4($t2) # load address of next node in $t3
		
		beq $t1, $a2, for_insert_index_found
		j for_insert_continue
		
		for_insert_index_found:
			# set current node's next value to the new node
			sw $v0, 4($t2)
			
			# set new node's next value to the "next" node
			sw $t3, 4($v0)
			
			j for_insert_done
			
		for_insert_continue:
		move $t2, $t3
		addi $t1, $t1, 1
		j for_insert
	
	for_insert_done:
	# increment list size and update return value.
	lw $t0, 0($a0)
	addi $t0, $t0, 1
	sw $t0, 0($a0)
	
	move $v0, $t0
	jr $ra


# Part 4
get_value:
	# $a0 has the list
	# $a1 has the index to look for.
	
	lw $t0, 0($a0) # load list size
	
	beqz $t0, get_value_invalid_args # empty list
	bltz $a1, get_value_invalid_args # negative index
	bge $a1, $t0, get_value_invalid_args # index >= list size
	j get_value_valid_args
	
	get_value_invalid_args:
		li $v0, -1
		li $v1, -1
		jr $ra
		
	get_value_valid_args:
	
	# $t0 has list size
	li $t1, 0
	lw $t2, 4($a0) # load head address into $t2
	
	for_get_value:
		beq $t1, $t0, for_get_value_done
		
		beq $t1, $a1, for_get_value_index_found
		j for_get_value_continue
		
		for_get_value_index_found:
			# current node address stored in $t2.
			lw $t5, 0($t2)
			j for_get_value_done
			
		for_get_value_continue:
		lw $t3, 4($t2) # load address of next node in $t3
		move $t2, $t3
		addi $t1, $t1, 1
		j for_get_value
		
	for_get_value_done:
	li $v0, 0
	move $v1, $t5
	jr $ra

# Part 5
set_value:
	# $a0 has list
	# $a1 has index
	# $a2 has new integer value
	
	lw $t0, 0($a0) # load list size
	
	beqz $t0, set_value_invalid_args # empty list
	bltz $a1, set_value_invalid_args # negative index
	bge $a1, $t0, set_value_invalid_args # index >= list size
	j set_value_valid_args
	
	set_value_invalid_args:
		li $v0, -1
		li $v1, -1
		jr $ra
		
	set_value_valid_args:
	
	# $t0 has list size
	li $t1, 0
	lw $t2, 4($a0) # load head address into $t2
	
	for_set_value:
		beq $t1, $t0, for_set_value_done
		
		beq $t1, $a1, for_set_value_index_found
		j for_set_value_continue
		
		for_set_value_index_found:
			lw $t5, 0($t2) # move currently stored value into $t5 before overwriting it.
			sw $a2, 0($t2) # store new value
			j for_set_value_done
			
		for_set_value_continue:
		lw $t3, 4($t2) # load address of next node in $t3
		move $t2, $t3
		addi $t1, $t1, 1
		j for_set_value
		
	for_set_value_done:
	
	li $v0, 0
	move $v1, $t5
	jr $ra

# Part 6
index_of:
	# $a0 has list
	# $a1 has number to find.
	
	lw $t0, 0($a0) # load list size
	
	beqz $t0, index_of_empty_list # empty list
	j index_of_non_empty
	
	index_of_empty_list:
		li $v0, -1
		jr $ra
		
	index_of_non_empty:
	
	# $t0 has list size
	li $t1, 0
	lw $t2, 4($a0) # load head address into $t2
	
	for_index_of:
		beq $t1, $t0, for_index_of_done
		
		lw $t5, 0($t2) # load current node's value.
		bne $t5, $a1, for_index_of_continue # if value != target we keep going
		
		# otherwise this is it.
		move $v0, $t1 # store index in return value
		jr $ra
		
		for_index_of_continue:
		lw $t3, 4($t2) # load address of next node in $t3
		move $t2, $t3
		addi $t1, $t1, 1
		j for_index_of
		
	 for_index_of_done:
	 # if we didn't return in the loop, the value doesn't exist.
	 li $v0, -1
	 jr $ra

# Part 7
remove:
	# $a0 has list
	# $a1 has number to find.
	
	
	# call index_of to see if the int is in the list and if so, which index we need to remove.
	# if the list is empty, func will return -1 so we can use that to check both fail conditions for the function.
	
	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $ra, 8($sp)
	
	# $a0 still has list
	# $a1 has num to find
	
	jal index_of
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	
	bltz $v0, remove_invalid_args
	j remove_valid_args
	
	remove_invalid_args:
		li $v0, -1
		li $v1, -1
		jr $ra
	
	remove_valid_args:
	
	# $v0 has the index we wanna look for.
	
	lw $t0, 0($a0) # load list size
	li $t1, 1 # $t1 keeps track of the index + 1 since we wanna use index + 1's next to connect the current node to. 
	lw $t2, 4($a0) # load head address into $t2
	
	beqz $v0, remove_head # removing index 0 is easy, we just set the list's head field to current head's next
	j for_remove # otherwise we enter the loop
	
	remove_head:
		lw $t5, 4($t2) # load head's next address.
		sw $t5, 4($a0) # store head's next as the new head.
		j for_remove_done
		
	for_remove:
		bge $t1, $t0, for_remove_done
		
		# address of current node in $t2
		lw $t3, 4($t2) # address of next node in $t3
		
		beq $t1, $v0, for_remove_index_found
		j for_remove_continue
		
		for_remove_index_found:
			beq $t1, $t0, remove_tail # removing tail is easy, just set current address to null terminator.
			j remove_non_tail
			
			remove_tail:
				sw $0, 4($t2)
				j for_remove_done
				
			remove_non_tail:
			# set next field of current node to the next field of the following node.
			
			lw $t5, 4($t3) # load next field of following node
			sw $t5, 4($t2) # store that in the current node's next field.
			j for_remove_done
		
		for_remove_continue:
		move $t2, $t3
		addi $t1, $t1, 1
		j for_remove
		
	for_remove_done:
	# decrement list size and update return value.
	lw $t0, 0($a0)
	addi $t0, $t0, -1
	sw $t0, 0($a0)
	
	move $v1, $v0
	li $v0, 0
	jr $ra

# Part 8
create_deck:
	
	addi $sp, $sp, -12
	sw $s0, 0($sp) # use $s0 to store the list.
	sw $s1, 4($sp) # $s1 and $s2 used for looping append.
	sw $s2, 8($sp)
	
	# create 8 bytes required for the IntArrayList.
	li $v0, 9
	li $a0, 8
	syscall
	
	# call init_list
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $a0, $v0
	
	jal init_list
	
	move $s0, $v0 # store newly initialized list in $s0.
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	li $s1, 0
	li $s2, 52
	for_init_deck:
		beq $s1, $s2, for_init_deck_done
		
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		
		move $a0, $s0
		li $a1, 0
		
		jal append
		
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		addi $s1, $s1, 1
		j for_init_deck
		
	for_init_deck_done:
	
	# deck stored in $s0
	
	# ***** insert number cards. *****
	li $t1, 2 # use $t1 to keep track of the rank
	li $t2, 9 # use $t2 as upper-bound in loop.
	
	lw $t3, 4($s0) # load head address into $t3
	
	for_create_number_cards:
		bgt $t1, $t2, for_create_number_cards_done
		
		# current node's address is in $t3.
		
		
		# ***** create clubs card *****
		li $t0, 68 # "D", cards face down by default.
		sb $t0, 0($t3)
		
		move $t0, $t1 # store current rank in $t0
		addi $t0, $t0, 48 # convert digit to ascii by adding 48.
		sb $t0, 1($t3) # store card rank
		
		li $t0, 67 # "C" for clubs
		sb $t0, 2($t3)
		
		sb $0, 3($t3) # store null terminator.
		
		lw $t3, 4($t3) # load address of next node.
		
		
		# ***** create diamonds card *****
		li $t0, 68 # "D", cards face down by default.
		sb $t0, 0($t3)
		
		move $t0, $t1 # store current rank in $t0
		addi $t0, $t0, 48 # convert digit to ascii by adding 48.
		sb $t0, 1($t3) # store card rank
		
		li $t0, 68 # "D" for diamonds
		sb $t0, 2($t3)
		
		sb $0, 3($t3) # store null terminator.
		
		lw $t3, 4($t3) # load address of next node.
		
		
		# ***** create hearts card *****
		li $t0, 68 # "D", cards face down by default.
		sb $t0, 0($t3)
		
		move $t0, $t1 # store current rank in $t0
		addi $t0, $t0, 48 # convert digit to ascii by adding 48.
		sb $t0, 1($t3) # store card rank
		
		li $t0, 72 # "H" for hearts
		sb $t0, 2($t3)
		
		sb $0, 3($t3) # store null terminator.
		
		lw $t3, 4($t3) # load address of next node.
		
		
		# ***** create spades card. *****
		li $t0, 68 # "D", cards face down by default.
		sb $t0, 0($t3)
		
		move $t0, $t1 # store current rank in $t0
		addi $t0, $t0, 48 # convert digit to ascii by adding 48.
		sb $t0, 1($t3) # store card rank
		
		li $t0, 83 # "S" for spades
		sb $t0, 2($t3)
		
		sb $0, 3($t3) # store null terminator.
		
		lw $t3, 4($t3) # load address of next node.
		
		addi $t1, $t1, 1 # increment rank.
		j for_create_number_cards
		
	for_create_number_cards_done:
	
	# write higher order cards ( tens,  jack, queen, king, ace.)
	# next node still in $t3, so we don't need to advance the pointer yet.
	li $t0, 68 # "D", cards face down by default. this doesn't change.
	
	# *****create tens *****
	li $t1, 84  # "T", rank of ten.
	
		# ***** create clubs card *****
		sb $t0, 0($t3) # store face down
		
		sb $t1, 1($t3) # store card rank
		
		li $t2, 67 # "C" for clubs
		sb $t2, 2($t3)
		
		sb $0, 3($t3) # store null terminator.
		
		lw $t3, 4($t3) # load address of next node.
		
		
		# ***** create diamonds card *****
		sb $t0, 0($t3) # store face down
		
		sb $t1, 1($t3) # store card rank
		
		li $t2, 68 # "D" for diamonds
		sb $t2, 2($t3)
		
		sb $0, 3($t3) # store null terminator.
		
		lw $t3, 4($t3) # load address of next node.
		
		
		# ***** create hearts card *****
		sb $t0, 0($t3) # store face down
		
		sb $t1, 1($t3) # store card rank
		
		li $t2, 72 # "H" for hearts
		sb $t2, 2($t3)
		
		sb $0, 3($t3) # store null terminator.
		
		lw $t3, 4($t3) # load address of next node.
		
		
		# ***** create spades card. *****
		sb $t0, 0($t3) # store face down
		
		sb $t1, 1($t3) # store card rank
		
		li $t2, 83 # "S" for spades
		sb $t2, 2($t3)
		
		sb $0, 3($t3) # store null terminator.
		
		lw $t3, 4($t3) # load address of next node.
	
	
	# create jacks
	li $t1, 74  # "J"
	
		# ***** create clubs card *****
		sb $t0, 0($t3) # store face down
		
		sb $t1, 1($t3) # store card rank
		
		li $t2, 67 # "C" for clubs
		sb $t2, 2($t3)
		
		sb $0, 3($t3) # store null terminator.
		
		lw $t3, 4($t3) # load address of next node.
		
		
		# ***** create diamonds card *****
		sb $t0, 0($t3) # store face down
		
		sb $t1, 1($t3) # store card rank
		
		li $t2, 68 # "D" for diamonds
		sb $t2, 2($t3)
		
		sb $0, 3($t3) # store null terminator.
		
		lw $t3, 4($t3) # load address of next node.
		
		
		# ***** create hearts card *****
		sb $t0, 0($t3) # store face down
		
		sb $t1, 1($t3) # store card rank
		
		li $t2, 72 # "H" for hearts
		sb $t2, 2($t3)
		
		sb $0, 3($t3) # store null terminator.
		
		lw $t3, 4($t3) # load address of next node.
		
		
		# ***** create spades card. *****
		sb $t0, 0($t3) # store face down
		
		sb $t1, 1($t3) # store card rank
		
		li $t2, 83 # "S" for spades
		sb $t2, 2($t3)
		
		sb $0, 3($t3) # store null terminator.
		
		lw $t3, 4($t3) # load address of next node.
		
		
	# create queens
	li $t1, 81  # "Q"
	
		# ***** create clubs card *****
		sb $t0, 0($t3) # store face down
		
		sb $t1, 1($t3) # store card rank
		
		li $t2, 67 # "C" for clubs
		sb $t2, 2($t3)
		
		sb $0, 3($t3) # store null terminator.
		
		lw $t3, 4($t3) # load address of next node.
		
		
		# ***** create diamonds card *****
		sb $t0, 0($t3) # store face down
		
		sb $t1, 1($t3) # store card rank
		
		li $t2, 68 # "D" for diamonds
		sb $t2, 2($t3)
		
		sb $0, 3($t3) # store null terminator.
		
		lw $t3, 4($t3) # load address of next node.
		
		
		# ***** create hearts card *****
		sb $t0, 0($t3) # store face down
		
		sb $t1, 1($t3) # store card rank
		
		li $t2, 72 # "H" for hearts
		sb $t2, 2($t3)
		
		sb $0, 3($t3) # store null terminator.
		
		lw $t3, 4($t3) # load address of next node.
		
		
		# ***** create spades card. *****
		sb $t0, 0($t3) # store face down
		
		sb $t1, 1($t3) # store card rank
		
		li $t2, 83 # "S" for spades
		sb $t2, 2($t3)
		
		sb $0, 3($t3) # store null terminator.
		
		lw $t3, 4($t3) # load address of next node.
		
		
	# create kings
	li $t1, 75  # "K"
	
		# ***** create clubs card *****
		sb $t0, 0($t3) # store face down
		
		sb $t1, 1($t3) # store card rank
		
		li $t2, 67 # "C" for clubs
		sb $t2, 2($t3)
		
		sb $0, 3($t3) # store null terminator.
		
		lw $t3, 4($t3) # load address of next node.
		
		
		# ***** create diamonds card *****
		sb $t0, 0($t3) # store face down
		
		sb $t1, 1($t3) # store card rank
		
		li $t2, 68 # "D" for diamonds
		sb $t2, 2($t3)
		
		sb $0, 3($t3) # store null terminator.
		
		lw $t3, 4($t3) # load address of next node.
		
		
		# ***** create hearts card *****
		sb $t0, 0($t3) # store face down
		
		sb $t1, 1($t3) # store card rank
		
		li $t2, 72 # "H" for hearts
		sb $t2, 2($t3)
		
		sb $0, 3($t3) # store null terminator.
		
		lw $t3, 4($t3) # load address of next node.
		
		
		# ***** create spades card. *****
		sb $t0, 0($t3) # store face down
		
		sb $t1, 1($t3) # store card rank
		
		li $t2, 83 # "S" for spades
		sb $t2, 2($t3)
		
		sb $0, 3($t3) # store null terminator.
		
		lw $t3, 4($t3) # load address of next node.
		
		
	# create aces
	li $t1, 65  # "A"
	
		# ***** create clubs card *****
		sb $t0, 0($t3) # store face down
		
		sb $t1, 1($t3) # store card rank
		
		li $t2, 67 # "C" for clubs
		sb $t2, 2($t3)
		
		sb $0, 3($t3) # store null terminator.
		
		lw $t3, 4($t3) # load address of next node.
		
		
		# ***** create diamonds card *****
		sb $t0, 0($t3) # store face down
		
		sb $t1, 1($t3) # store card rank
		
		li $t2, 68 # "D" for diamonds
		sb $t2, 2($t3)
		
		sb $0, 3($t3) # store null terminator.
		
		lw $t3, 4($t3) # load address of next node.
		
		
		# ***** create hearts card *****
		sb $t0, 0($t3) # store face down
		
		sb $t1, 1($t3) # store card rank
		
		li $t2, 72 # "H" for hearts
		sb $t2, 2($t3)
		
		sb $0, 3($t3) # store null terminator.
		
		lw $t3, 4($t3) # load address of next node.
		
		
		# ***** create spades card. *****
		sb $t0, 0($t3) # store face down
		
		sb $t1, 1($t3) # store card rank
		
		li $t2, 83 # "S" for spades
		sb $t2, 2($t3)
		
		sb $0, 3($t3) # store null terminator.
		
		lw $t3, 4($t3) # load address of next node.
	
	move $v0, $s0
	
	lw $s0, 0($sp) # use $s0 to store the list.
	lw $s1, 4($sp) # $s1 and $s2 used for looping append.
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	
	jr $ra

# Part 9
draw_card:
	# $a0 has address of a deck.
	
	addi $sp, $sp, -4
	sw $s0, 0($sp) # used to store head value before removing it.
	
	lw $t0, 0($a0) # load list size
	
	blez $t0, draw_card_invalid_args # list is empty.
	j draw_card_valid_args
	
	draw_card_invalid_args:
		li $v0, -1
		li $v1, -1
		jr $ra
	
	draw_card_valid_args:
	# get head value then remove it (index 0) store in $s0.
	
	lw $t0, 4($a0) # load head address
	lw $s0, 0($t0) # load num field.
	
	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $ra, 4($sp)
	
	# $a0 still has list
	move $a1, $s0 # value of num is what we wanna remove, this is guaranteed to remove the correct one. head = leftmost, and the value is there.
	
	jal remove
	
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	
	li $v0, 0
	move $v1, $s0
	
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

# Part 10
deal_cards:
jr $ra

# Part 11
card_points:
jr $ra

# Part 12
simulate_game:
jr $ra

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
