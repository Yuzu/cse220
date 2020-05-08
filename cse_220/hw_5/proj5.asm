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
		lw $s0, 0($sp)
		addi $sp, $sp, 4
		
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
	# $a0 has deck
	# $a1 has array of ptrs to initialized arraylists representing players
	# $a2 has the number of players in the game, len($a1).
	# $a3 has number of cards each player should get.
	
	blez $a2, deal_cards_invalid_args # number of players <= 0
	blez $a3, deal_cards_invalid_args # cards per player <= 0
	
	lw $t0, 0($a0) # load deck size
	blez $a0, deal_cards_invalid_args # empty deck
	
	j deal_cards_valid_args
	deal_cards_invalid_args:
		li $v0, -1
		jr $ra
	
	deal_cards_valid_args:
	# use $s0, 1, 2, and 3.
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	
	# while loop - break conditions are: deck size = 0, OR each player has cards_per_player.
	# DRAW CARD -> change to face up by shifting -> APPEND -> add player's total cards to running sum
	# check if deck is empty, if not -> repeat for above rest of players OTHERWISE if empty -> break
	# multiply num players by max_cards, compare to running sum. if they're ==, everyone has max amount -> break, OTHERWISE continue
	
	li $s3, 0 # running sum of total cards dealt, we're gonna return this value.
	while_deal_cards:
		
		li $s0, 0 # inner loop
		# loop through to number of players
		
		li $s1, 0 # running sum.
		move $s2, $a1 # use $s2 as ptr to array of players.
		
		# deal each player a card.
		for_deal_cards:
		
			lw $t0, 0($a0) # load deck size
			beqz $t0, while_deal_cards_done # if deck is empty we're done
			
			beq $s0, $a2, for_deal_cards_done # we've dealt each player a card.
			
			# ***** draw a card. *****
			
			addi $sp, $sp, -20 
			sw $a0, 0($sp)
			sw $a1, 4($sp)
			sw $a2, 8($sp)
			sw $a3, 12($sp)
			sw $ra, 16($sp)
			
			# $a0 still has the deck.
			jal draw_card
			
			lw $a0, 0($sp)
			lw $a1, 4($sp)
			lw $a2, 8($sp)
			lw $a3, 12($sp)
			lw $ra, 16($sp)
			addi $sp, $sp, 20
			
			# ***** update card to be faced up *****
			# card value stored in $v1.
			addi $v1, $v1, 17 # shift ascii value from "D" to "U"
			
			
			# *****append new card to player's linkedlist*****
			# load current player pointer.
			lw $t0, 0($s2) # store address of player's linkedlist here.
			
			# call append
			
			addi $sp, $sp, -20 
			sw $a0, 0($sp)
			sw $a1, 4($sp)
			sw $a2, 8($sp)
			sw $a3, 12($sp)
			sw $ra, 16($sp)
			
			move $a0, $t0 # appending to player's linked list, not the deck.
			move $a1, $v1 # store updated value in $a1.
			
			jal append
			
			lw $a0, 0($sp)
			lw $a1, 4($sp)
			lw $a2, 8($sp)
			lw $a3, 12($sp)
			lw $ra, 16($sp)
			addi $sp, $sp, 20
			
			# new size of list in $v0.
			add $s1, $s1, $v0 # update running sum.
			
			# look at next player and loop over.
			addi $s0, $s0, 1 # increment players looked at.
			addi $s2, $s2, 4 # look at next player.
			addi $s3, $s3, 1 # increment return value.
			j for_deal_cards
		
		for_deal_cards_done:
		
		# multiply num players by max_cards, compare to running sum. if they're ==, everyone has max amount -> break, OTHERWISE continue
		
		mul $t0, $a2, $a3 # multiply num players by cards_per_players
		beq $t0, $s1, while_deal_cards_done # max number of cards.
		
		# otherwise we continue.
		j while_deal_cards
		
	while_deal_cards_done:
	move $v0, $s3
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16
	
	jr $ra

# Part 11
card_points:
	# $a0 has the integer of the card.
	
	# ***** check for valid orientation *****
	move $t0, $a0 # store card value in $t0.
	# shift left by 3 bytes and 3 to the right, only remaining value is the orientation of the card.
	sll $t0, $t0, 24
	srl $t0, $t0, 24
	
	li $t1, 68 # check for "D"
	beq $t0, $t1, card_points_valid_orientation
	
	li $t1, 85 # check for "U"
	beq $t0, $t1, card_points_valid_orientation
	
	# otherwise invalid orientation.
	j card_points_invalid_card
	
	card_points_valid_orientation:
	
	
	# ***** check for valid rank. *****
	move $t0, $a0 # store card value in $t0.
	# shift left by 2 bytes and 3 to the right, only remaining value is the card rank.
	sll $t0, $t0, 16
	srl $t0, $t0, 24
	
	# check for letter cards
	li $t1, 84 # check for "T"
	beq $t0, $t1, card_points_valid_rank
	
	li $t1, 74 # "check for "J"
	beq $t0, $t1, card_points_valid_rank
	
	li $t1, 81 # "check for "Q"
	beq $t0, $t1, card_points_valid_rank
	
	li $t1, 75 # "check for "K"
	beq $t0, $t1, card_points_valid_rank
	
	li $t1, 65 # "check for "A"
	beq $t0, $t1, card_points_valid_rank
	
	# check for number cards.
	li $t1, 50 # check for "2"
	blt $t0, $t1, card_points_invalid_card
	
	li $t1, 57 # check for "9"
	bgt $t0, $t1, card_points_invalid_card
	
	card_points_valid_rank:

	# ***** check for valid suit *****
	move $t0, $a0 # store card value in $t0.
	# shift right by 2 bytes, only remaining value is the suit.
	srl $t0, $t0, 16 
	
	li $t1, 67 # "check for "C"
	beq $t0, $t1, card_points_valid_suit
	
	li $t1, 68 # "check for "D"
	beq $t0, $t1, card_points_valid_suit
	
	li $t1, 72 # "check for "H"
	beq $t0, $t1, card_points_valid_suit
	
	li $t1, 83 # "check for "S"
	beq $t0, $t1, card_points_valid_suit
	
	# otherwise invalid suit.
	j card_points_invalid_card
	
	card_points_valid_suit:

	# ***** check for hearts *****
	# suit still in $t0, we can reuse the previous statements above.
	
	li $t1, 72 # "check for "H"
	beq $t0, $t1, card_points_hearts
	
	li $t1, 83 # "check for "S"
	beq $t0, $t1, card_points_spades
	
	# otherwise card value is 0.
	card_points_nothing:
	li $v0, 0 
	jr $ra
	
	card_points_hearts:
	li $v0, 1
	jr $ra
	
	#  ***** check for queen of spades. *****
	card_points_spades:
		move $t0, $a0 # store card value in $t0.
		
		# shift left by 2 bytes and 3 to the right, only remaining value is the card rank.
		sll $t0, $t0, 16
		srl $t0, $t0, 24
		
		li $t1, 81 # check for "Q"
		bne $t0, $t1, card_points_nothing
		# otherwise we return 13.
		li $v0, 13
		jr $ra
		
	card_points_invalid_card:
		li $v0, -1
		jr $ra


# Part 12
simulate_game:
	# $a0 has deck of face down cards
	# $a1 has pointer to list of UNINITIALIZED LL structs
	# $a2 has the number of rounds to play.
	
	# use $s0 to keep track of # of rounds
	# use $s1 to keep track of player's scores (check doc for how exactly this works.)
	# use $s2 to keep track of who played the highest card in the last round. (index of that player.)
	# use $s3 to keep track of who played the highest card in THIS ROUND. ( index of that player).
	# use $s4 to keep track of current suit on the top (the suit that a player has to match)
	# use $s5 to keep track of how many points are earned this round by everyone.
	# use $s6 to keep track of the highest ranked card in this round.
	# use $s7 to keep track of pointer to current player.  (stores address of that player)
	
	addi $sp, $sp, -32
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	
	# call init_list for each player to initialize players (4 total)
	addi $sp, $sp, -16
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $ra, 12($sp)
	
	lw $a0, 0($a1)
	jal init_list 
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	
	# init player 2
	addi $sp, $sp, -16
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $ra, 12($sp)
	
	lw $a0, 4($a1)
	jal init_list 
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	
	# init player 3
	addi $sp, $sp, -16
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $ra, 12($sp)
	
	lw $a0, 8($a1)
	jal init_list 
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	
	# init player 4
	addi $sp, $sp, -16
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $ra, 12($sp)
	
	lw $a0, 12($a1)
	jal init_list 
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	
	# deal cards to players using deal_cards
	addi $sp, $sp, -16
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $ra, 12($sp)
	
	# $a0 has the deck
	# $a1 has players LL
	li $a2, 4 # 4 players
	li $a3, 13 # 52 card deck / 4 players = 13 per player.
	
	jal deal_cards
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	
	# play out 1st round b/c of how unique it is
	
	li $s0, 0 # 0 rounds played.
	li $s1, 0 # total score to return later on.
	li $s2, 0 # keep track of player who played highest card in the LAST round (index)
	li $s3, 0 # keep track of who played highest card in THIS round (index)
	li $s4, 67 # keep track of current suit, initialize w/ clubs since we ALWAYS start with clubs.
	li $s5, 0 # keep track of amount of points earned this round
	li $s6, 0 # keep track of highest ranked card's rank this round.
	li $s7, 0 # keep track of current player we're looking at. (stores address of that player)
	
	# loop through each player, look for player w/ the 2 of clubs
	
	# check player 0
	li $t0, 4403797 # face UP 2 of clubs is U2C -> 0x00433255 -> 4403797
	lw $t1, 0($a1) # use $t1 as ptr to each player.
	
	# call remove on the player. if it returns -1, they don't have the 2 of clubs.
	addi $sp, $sp, -16
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $ra, 12($sp)
	
	move $a0, $t1 
	move $a1, $t0
	
	jal remove
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	
	beqz $v0, two_of_clubs_found
	# otherwise we check the next player.
	
	addi $s3, $s3, 1 # assume next player will have 2 of clubs.
	
	# ***** check player 1 *****
	li $t0, 4403797 # face UP 2 of clubs is U2C -> 0x00433255 -> 4403797
	lw $t1, 4($a1) # use $t1 as ptr to each player.
	
	# call remove on the player. if it returns -1, they don't have the 2 of clubs.
	addi $sp, $sp, -16
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $ra, 12($sp)
	
	move $a0, $t1 
	move $a1, $t0
	
	jal remove
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	
	beqz $v0, two_of_clubs_found
	# otherwise we check the next player.
	
	addi $s3, $s3, 1 # assume next player will have 2 of clubs.
	
	
	# ***** check player 2 *****
	li $t0, 4403797 # face UP 2 of clubs is U2C -> 0x00433255 -> 4403797
	lw $t1, 8($a1) # use $t1 as ptr to each player.
	
	# call remove on the player. if it returns -1, they don't have the 2 of clubs.
	addi $sp, $sp, -16
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $ra, 12($sp)
	
	move $a0, $t1 
	move $a1, $t0
	
	jal remove
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	
	beqz $v0, two_of_clubs_found
	# otherwise we check the next player.
	
	addi $s3, $s3, 1 # assume next player will have 2 of clubs.
	
	
	# *****check player 3 ***** PLAYER 3 HAS TO HAVE IT IF NO ONE ELSE DOES.
	li $t0, 4403797 # face UP 2 of clubs is U2C -> 0x00433255 -> 4403797
	lw $t1, 12($a1) # use $t1 as ptr to each player.
	
	# call remove on the player. if it returns -1, they don't have the 2 of clubs.
	addi $sp, $sp, -16
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $ra, 12($sp)
	
	move $a0, $t1 
	move $a1, $t0
	
	jal remove
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16

	two_of_clubs_found:
	
	move $s2, $s3 # use $s2 as index of max to start indexing from.
	# $s3 has the index of the player who played the 2 of clubs. the card has been discarded using remove, so we need the rest of the players to play cards now.
	li $s6, 50 # 2 of clubs has rank 2, the highest so far.
	
	# move ptr to the player who played the 2 of clubs ( their index is in $s3)
	li $t0, 4
	mul $t0, $t0, $s3 # store offset in $t0. 
	
	move $s7, $a1 # use $s7 as ptr to player array.
	
	add $s7, $s7, $t0 # add offset to find who played the 2 of clubs.
	
	# pointer of $s7 now at the player who played 2 of clubs
	# use $s2 and adding 4 to $t1 to keep looking at the next player.
	
	# look at the next 3 players.
	addi $s7, $s7, 4 # move ptr to next player.
	addi $s2, $s2, 1
	li $t0, 4
	bge $s2, $t0, round_1_wrap_over_1
	j round_1_valid_index_1
	
	round_1_wrap_over_1:
		# reset pointer and index to beginning of array.
		li $s2, 0
		move $s7, $a1
		
	round_1_valid_index_1:
	# call play_card on current player w/ the clubs suit.
	
	addi $sp, $sp, -16
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $ra, 12($sp)
	
	move $a0, $s7 # $a0 needs pointer to player struct
	move $a1, $s4 # $a1 needs the suit.
	
	jal play_card
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	
	addi $sp, $sp, -4 # we need to preserve the $v0 register (card's point value) to add to the running sum (overwritten by compare_ranks), no more $s registers so we have to use the stack.
	sw $v0, 0($sp)
	bltz $v1, round_1_continue_1 # player can't match the suit. no need to try and compare for a new max.
	
	
	# otherwise we compare the returned rank in $v1 to the current max.
	# call compare_ranks
	
	addi $sp, $sp, -16
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $ra, 12($sp)
	
	move $a0, $s6 # move the current max to $v0. 
	move $a1, $v1 # $v1 still has the returned rank from play_card.
	
	jal compare_ranks
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	
	# if compare_ranks returns 1, that means we have a new max.
	bltz $v0, round_1_continue_1 # if the return value is neg that means the current max is greater.
	# otherwise we update max values.
	move $s3, $s2 # update index of player w/ max
	move $s6, $v1 # update rank of highest ranked card.
	
	round_1_continue_1:
	
	lw $v0, 0($sp) # restore return value from play_card earlier.
	addi $sp, $sp, 4
	
	add $s5, $s5, $v0 # add pts to running sum.
	
	
	# LOOK AT NEXT PLAYER 
	addi $s7, $s7, 4 # move ptr to next player.
	addi $s2, $s2, 1
	li $t0, 4
	bge $s2, $t0, round_1_wrap_over_2
	j round_1_valid_index_2
	
	round_1_wrap_over_2:
		# reset pointer and index to beginning of array.
		li $s2, 0
		move $s7, $a1
		
	round_1_valid_index_2:
	# call play_card on current player w/ the clubs suit.
	
	addi $sp, $sp, -16
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $ra, 12($sp)
	
	move $a0, $s7 # $a0 needs pointer to player struct
	move $a1, $s4 # $a1 needs the suit.
	
	jal play_card
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	
	addi $sp, $sp, -4 # we need to preserve the $v0 register to add to the running sum (overwritten by compare_ranks), no more $s registers so we have to use the stack.
	sw $v0, 0($sp)
	bltz $v1, round_1_continue_2 # player can't match the suit. no need to try and compare for a new max.
	
	# otherwise we compare the returned rank in $v1 to the current max.
	# call compare_ranks
	
	addi $sp, $sp, -16
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $ra, 12($sp)
	
	move $a0, $s6 # move the current max to $v0. 
	move $a1, $v1 # $v1 still has the returned rank from play_card.
	
	jal compare_ranks
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	
	# if compare_ranks returns 1, that means we have a new max.
	bltz $v0, round_1_continue_2 # if the return value is neg that means the current max is greater.
	# otherwise we update max values.
	move $s3, $s2 # update index of player w/ max
	move $s6, $v1 # update rank of highest ranked card.
	
	round_1_continue_2:
	
	lw $v0, 0($sp) # restore return value from play_card earlier.
	addi $sp, $sp, 4
	add $s5, $s5, $v0 # add pts to running sum.
	
	# LOOK AT NEXT PLAYER
	addi $s7, $s7, 4 # move ptr to next player.
	addi $s2, $s2, 1
	li $t0, 4
	bge $s2, $t0, round_1_wrap_over_3
	j round_1_valid_index_3
	
	round_1_wrap_over_3:
		# reset pointer and index to beginning of array.
		li $s2, 0
		move $s7, $a1
		
	round_1_valid_index_3:
	# call play_card on current player w/ the clubs suit.
	
	addi $sp, $sp, -16
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $ra, 12($sp)
	
	move $a0, $s7 # $a0 needs pointer to player struct
	move $a1, $s4 # $a1 needs the suit.
	
	jal play_card
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	
	addi $sp, $sp, -4 # we need to preserve the $v0 register to add to the running sum (overwritten by compare_ranks), no more $s registers so we have to use the stack.
	sw $v0, 0($sp)
	bltz $v1, round_1_continue_3 # player can't match the suit. no need to try and compare for a new max.
	
	# otherwise we compare the returned rank in $v1 to the current max.
	# call compare_ranks
	
	addi $sp, $sp, -16
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $ra, 12($sp)
	
	move $a0, $s6 # move the current max to $v0. 
	move $a1, $v1 # $v1 still has the returned rank from play_card.
	
	jal compare_ranks
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	
	# if compare_ranks returns 1, that means we have a new max.
	bltz $v0, round_1_continue_3 # if the return value is neg that means the current max is greater.
	# otherwise we update max values.
	move $s3, $s2 # update index of player w/ max
	move $s6, $v1 # update rank of highest ranked card.
	
	round_1_continue_3:
	
	lw $v0, 0($sp) # restore return value from play_card earlier.
	addi $sp, $sp, 4
	add $s5, $s5, $v0 # add pts to running sum.
	
	# give all the points to the player w/ the max rank card played.
	# score for this round in $s5
	
	li $t0, 8 # shift amt
	
	# player to get points stored in $s3
	mul $t0, $s3, $t0 # player index * 8
	sllv $s5, $s5, $t0
	
	add $s1, $s1, $s5
	move $s7, $a0 # reset pointer to players list.
	move $s2, $s3 # move index of THIS ROUND'S MAX to PREVIOUS ROUND'S MAX ( move $s2, $s3)
	# no need to reset this round's max or its value b/c it's overwritten later anyways.
	li $s5, 0# reset $s5 ( running sum of pts this round)
	addi $s0, $s0, 1 # increment # of rounds played.
	
	# ***** main loop for playing rounds. *****
	
	# ***** process for the rest of the players (DO THIS 3 TIMES.): *****
	
	# look for card of current suit (helper function called play_card)
	# if helper function play_card returns -1, they don't have a card of that suit. So we call draw_card on them. because the suit doesn't match, 
	# they can't be in the running to gain points. we can just jump past setting a new max using a label called different_suit_played.
	
	# otherwise helper function play_card will call card_points on that node, save the card value for returning,  and then call remove on the node.
	# helper function will return the points of the card in $v0 and the RANK (need to shift) of the card in $v1.
	# compare the rank of the returned card to the current max. if we have a new max, we update the player + max values.
	
	# DIFFERENT_SUIT_PLAYED LABEL HERE ***** Changed to "continue" *****
	# add the points of that card to the running sum
	# go to next player and increment $s2 (index of current player.).
	# if the index is >= 4, we mod the index (loop back to 0).
	# we also reset the pointer for the current player.
	
	# ***** AFTER DOING THIS FOR THE REMAINDING 3 PLAYERS *****
	
	# give all the points to the player w/ the max rank card played.
	
	# reset pointer to players list.
	# move index of THIS ROUND'S MAX to PREVIOUS ROUND'S MAX ( move $s2, $s3)
	# no need to reset this round's max or its value b/c it's overwritten later anyways.
	# reset $s5 ( running sum of pts this round)
	# increment # of rounds played and loop over.
		
	# give all the points to the player w/ the max rank card played.
	# score for this round in $s5
	
	for_simulate_game:
		beq $s0, $a2, for_simulate_game_done # if # of rounds > rounds to play, we break.
		
		# move ptr to the player who played the max card last round ( index in $s2).
		li $t0, 4
		mul $t0, $t0, $s2 # store offset in $t0. 
	
		move $s7, $a1 # use $s7 as ptr to player array.
	
		add $s7, $s7, $t0 # add offset to find who played the max last round.
		# pointer of $s7 now at the player who played the max last round.
		
		# call draw_card on them. we set that player and card's rank as the max for now.
		
		addi $sp, $sp, -16
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)
		sw $ra, 12($sp)
		
		lw $a0, 0($s7) # load player address
		
		jal draw_card
		
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $ra, 12($sp)
		addi $sp, $sp, 16
		
		# $v1 has the value of the card.
		move $t0, $v1 # use $t0 to manipulate card value.
		
		# update current suit 
		# shift right by 2 bytes, only remaining value is the suit.
		srl $s4, $t0, 16
		
		# for now this player remains the max. we just need to update the actual max value.
		# shift left by 2 bytes and 3 to the right, only remaining value is the card rank.
		sll $s6, $t0, 16
		srl $s6, $s6, 24
		
		# get the point value of this card and add it.
		addi $sp, $sp, -16
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)
		sw $ra, 12($sp)
		
		move $a0, $v1
		
		jal card_points
		
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $ra, 12($sp)
		addi $sp, $sp, 16
		
		add $s5, $s5, $v0 # add pts to running sum.
		
		
		# ***** at the beginning of each of the 3 segments below: *****
		# go to next player and increment $s2 (index of 1st player).
		# if the index is >= 4, we mod reset the index to 0.
		# we also reset the pointer for the current player.
		
		# ***** 1 OF 3 *****
		addi $s7, $s7, 4 # move ptr to next player.
		addi $s2, $s2, 1
		li $t0, 4
		bge $s2, $t0, wrap_over_1
		j valid_index_1
	
		wrap_over_1:
			# reset pointer and index to beginning of array.
			li $s2, 0
			move $s7, $a1
	
		valid_index_1:
		
		# call play_card on current player
	
		addi $sp, $sp, -16
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)
		sw $ra, 12($sp)
	
		move $a0, $s7 # $a0 needs pointer to player struct
		move $a1, $s4 # $a1 needs the suit.
	
		jal play_card
	
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $ra, 12($sp)
		addi $sp, $sp, 16
	
		addi $sp, $sp, -4 # we need to preserve the $v0 register to add to the running sum (overwritten by compare_ranks), no more $s registers so we have to use the stack.
		sw $v0, 0($sp)
		bltz $v1, continue_1 # player can't match the suit. no need to try and compare for a new max.

		# otherwise we compare the returned rank in $v1 to the current max.
		# call compare_ranks
	
		addi $sp, $sp, -16
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)
		sw $ra, 12($sp)
	
		move $a0, $s6 # move the current max to $v0. 
		move $a1, $v1 # $v1 still has the returned rank from play_card.
	
		jal compare_ranks
	
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $ra, 12($sp)
		addi $sp, $sp, 16
	
		# if compare_ranks returns 1, that means we have a new max.
		bltz $v0, continue_1 # if the return value is neg that means the current max is greater.
		# otherwise we update max values.
		move $s3, $s2 # update index of player w/ max
		move $s6, $v1 # update rank of highest ranked card.
	
		continue_1:
		lw $v0, 0($sp) # restore return value from play_card earlier.
		addi $sp, $sp, 4
		add $s5, $s5, $v0 # add pts to running sum.
		
		
		# ***** 2 OF 3 *****
		addi $s7, $s7, 4 # move ptr to next player.
		addi $s2, $s2, 1
		li $t0, 4
		bge $s2, $t0, wrap_over_2
		j valid_index_2
	
		wrap_over_2:
			# reset pointer and index to beginning of array.
			li $s2, 0
			move $s7, $a1
	
		valid_index_2:
		
		# call play_card on current player
		addi $sp, $sp, -16
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)
		sw $ra, 12($sp)
	
		move $a0, $s7 # $a0 needs pointer to player struct
		move $a1, $s4 # $a1 needs the suit.
	
		jal play_card
	
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $ra, 12($sp)
		addi $sp, $sp, 16
		
		addi $sp, $sp, -4 # we need to preserve the $v0 register to add to the running sum (overwritten by compare_ranks), no more $s registers so we have to use the stack.
		sw $v0, 0($sp)
		bltz $v1, continue_2 # player can't match the suit. no need to try and compare for a new max.
		
		# otherwise we compare the returned rank in $v1 to the current max.
		# call compare_ranks
	
		addi $sp, $sp, -16
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)
		sw $ra, 12($sp)
	
		move $a0, $s6 # move the current max to $v0. 
		move $a1, $v1 # $v1 still has the returned rank from play_card.
	
		jal compare_ranks
	
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $ra, 12($sp)
		addi $sp, $sp, 16
	
		# if compare_ranks returns 1, that means we have a new max.
		bltz $v0, continue_2 # if the return value is neg that means the current max is greater.
		# otherwise we update max values.
		move $s3, $s2 # update index of player w/ max
		move $s6, $v1 # update rank of highest ranked card.
	
		continue_2:
		lw $v0, 0($sp) # restore return value from play_card earlier.
		addi $sp, $sp, 4
		add $s5, $s5, $v0 # add pts to running sum.
		
		
		# ***** 3 OF 3 *****
		addi $s7, $s7, 4 # move ptr to next player.
		addi $s2, $s2, 1
		li $t0, 4
		bge $s2, $t0, wrap_over_3
		j valid_index_3
	
		wrap_over_3:
			# reset pointer and index to beginning of array.
			li $s2, 0
			move $s7, $a1
	
		valid_index_3:
		
		# call play_card on current player
		addi $sp, $sp, -16
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)
		sw $ra, 12($sp)
	
		move $a0, $s7 # $a0 needs pointer to player struct
		move $a1, $s4 # $a1 needs the suit.
	
		jal play_card
	
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $ra, 12($sp)
		addi $sp, $sp, 16
		
		addi $sp, $sp, -4 # we need to preserve the $v0 register to add to the running sum (overwritten by compare_ranks), no more $s registers so we have to use the stack.
		sw $v0, 0($sp)
		bltz $v1, continue_3 # player can't match the suit. no need to try and compare for a new max.
		
		# otherwise we compare the returned rank in $v1 to the current max.
		# call compare_ranks
	
		addi $sp, $sp, -16
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)
		sw $ra, 12($sp)
	
		move $a0, $s6 # move the current max to $v0. 
		move $a1, $v1 # $v1 still has the returned rank from play_card.
	
		jal compare_ranks
	
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $ra, 12($sp)
		addi $sp, $sp, 16
	
		# if compare_ranks returns 1, that means we have a new max.
		bltz $v0, continue_3 # if the return value is neg that means the current max is greater.
		# otherwise we update max values.
		move $s3, $s2 # update index of player w/ max
		move $s6, $v1 # update rank of highest ranked card.
	
		continue_3:
		lw $v0, 0($sp) # restore return value from play_card earlier.
		addi $sp, $sp, 4
		add $s5, $s5, $v0 # add pts to running sum.
		
		# ***** END OF ROUND CALCULATIONS *****
		li $t0, 8 # shift amt
	
		# player to get points stored in $s3
		mul $t0, $s3, $t0 # player index * 8
		sllv $s5, $s5, $t0
	
		add $s1, $s1, $s5
		move $s7, $a0 # reset pointer to players list.
		move $s2, $s3 # move index of THIS ROUND'S MAX to PREVIOUS ROUND'S MAX ( move $s2, $s3)
		# no need to reset this round's max or its value b/c it's overwritten later anyways.
		li $s5, 0 # reset $s5 ( running sum of pts this round)
		addi $s0, $s0, 1 # increment # of rounds played.
		j for_simulate_game
		
	for_simulate_game_done:
	move $v0, $s1
	
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	addi $sp, $sp, 32
	
	jr $ra



compare_ranks:
	# $a0 has the rank of a card
	# $a1 has the rank of another card.
	
	# determine whether we're looking at 2-9 or a letter card/10.
	
	li $t0, 50 # "2" in ascii
	li $t1, 57 # "9" in ascii
	
	bgt $a0, $t1, card_one_greater_than_9 # card one is a letter card/10
	# otherwise card one is a number card.
	
	bgt $a1, $t1, card_two_max # if card one is a number card and card two is a letter/10 card, two is greater no questions asked.
	# otherwise they're both number cards.
	j both_number_cards
	
	card_one_greater_than_9:
	bgt $a1, $t1, both_greater_than_9 # if both are letter/10 cards, we need to compare further.
	# otherwise card two is a number card so card one is the max.
	j card_one_max
	
	both_number_cards:
		# number cards are in sequence we can just compare their raw ascii values.
		bgt $a1, $a0, card_two_max # card 2 > card 1
		j card_one_max # card 2 < card 1
		
	both_greater_than_9:
		li $t0, 84 # "T"
		li $t1, 74  # "J"
		li $t2, 81 # "Q"
		li $t3, 75 # "K"
		li $t4, 65 # "A"
		
		# aces are the highest no matter what.
		beq $a0, $t4, card_one_max
		beq $a1, $t4, card_two_max 
		
		beq $a0, $t0, card_two_max # tens are the lowest, if card one is 10 then card two MUST be greater.
		beq $a1, $t0, card_one_max # opposite applies here.
		
		beq $a0, $t1, card_two_max # accounted for tens already, so jacks are the next "lowest".
		beq $a1, $t1, card_one_max # read above.
		
		beq $a0, $t2, card_two_max # accounted for tens and jacks already, queens are next "lowest"
		beq $a1, $t2, card_one_max
		
	card_one_max:
	li $v0, -1
	jr $ra
	
	card_two_max:
	li $v0, 1
	jr $ra
	
	# for our purposes, there will never be a rank comparison between different suits, and decks will have no dupes, so no ties.
	
		
play_card:
	# $a0 has a pointer to a player struct.
	# $a1 has the suit to look for
	
	addi $sp, $sp, -12
	sw $s0, 0($sp) # use $s0 to store rank of card
	sw $s1, 4($sp) # use $s1 to store point value of card
	sw $s2, 8($sp) # use $s2 to store value of card (face up/suit/rank and all)
	
	lw $t0, 0($a0) # use $t0 as ptr to the player.
	
	li $t1, 0
	lw $t2, 0($t0) # load size of list
	lw $t3, 4($t0) # load head of list
	
	for_play_card:
		beq $t1, $t2, for_play_card_done # suit not found.
		
		lw $t4, 0($t3) # load value of current node into $t4.
		
		# shift right by 2 bytes, only remaining value is the suit.
		srl $t4, $t4, 16
		
		beq $t4, $a1, suit_found
		j for_play_card_continue
		
		suit_found:
			# calculate card rank.
			lw $t4, 0($t3) # load value of current node into $t4. 
			move $s2, $t4 # store card value into $s2
			
			# shift left by 2 bytes and 3 to the right, only remaining value is the card rank.
			sll $t4, $t4, 16
			srl $t4, $t4, 24
			move $s0, $t4
			
			# call card points on the card value
			
			addi $sp, $sp, -12
			sw $a0, 0($sp)
			sw $a1, 4($sp)
			sw $ra, 8($sp)
			
			move $a0, $s2 # move card value into $a0
			
			jal card_points
			
			lw $a0, 0($sp)
			lw $a1, 4($sp)
			lw $ra, 8($sp)
			addi $sp, $sp, 12
			
			move $s1, $v0 # card point in $v0, move it to $s1
			
			# remove the card.
			
			addi $sp, $sp, -12
			sw $a0, 0($sp)
			sw $a1, 4($sp)
			sw $ra, 8($sp)
			
			lw $a0, 0($a0) # use $t0 as ptr to the player.
			move $a1, $s2 # move card value to remove
			
			jal remove
			
			lw $a0, 0($sp)
			lw $a1, 4($sp)
			lw $ra, 8($sp)
			addi $sp, $sp, 12
			
			move $v0, $s1 # points
			move $v1, $s0 # rank
			
			lw $s0, 0($sp) 
			lw $s1, 4($sp)
			lw $s2, 8($sp)
			addi $sp, $sp, 12
			
			jr $ra
			
		for_play_card_continue:
		addi $t1, $t1, 1
		lw $t3, 4($t3) # load next node.
		j for_play_card
	
	for_play_card_done:
	# suit not found, we just call deal_card. return -1 in rank since we don't wanna consider it as a max, but still need the point value of the card.
	
	lw $t0, 0($a0) # use $t0 as ptr to the player.
	
	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $ra, 8($sp)
	
	move $a0, $t0 
	
	jal draw_card
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	
	# integer of card will be in $v1. we need to call card_points now.
	
	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $ra, 8($sp)
	
	move $a0, $v1
	
	jal card_points
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	
	# card point value will be stored in $v0.
	
	lw $s0, 0($sp) 
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	
	# value still in $v0.
	li $v1, -1
	
	jr $ra

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
