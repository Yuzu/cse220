# Tim Wu
# TIMWU
# 112550028

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################

.text

# Part I
compare_to:
	# $a0 has ptr to customer struct, c1
	# $a1 has ptr to customer struct, c2
	
	# customer priority = fame + (10 x wait_time)
	
	# customer id = bytes 0-3 (word)
	# customer fame = byte 4-5 (short)
	# customer wait time = byte 6-7 (short)
	
	# calculate c1 weight
	move $t0, $a0 # use $t0 as pointer to c1
	
	addi $t0, $t0, 4 # look past ID
	lhu $t1, 0($t0) # load fame
	
	addi $t0, $t0, 2 # look past fame
	lhu $t2, 0($t0) # load wait time
	
	li $t0, 10
	mult $t0, $t2 # 10 * wait time
	mflo $t8 # store product in $t8
	
	add $t8, $t8, $t1 # fame + the product ( 10 * wait time)
	# c1 weight stored in $t8
	
	
	# calculate c2 weight
	move $t0, $a1 # use $t0 as ptr to c2
	
	addi $t0, $t0, 4 # look past ID
	lhu $t3, 0($t0) # load fame
	
	addi $t0, $t0, 2 # look past fame
	lhu $t4, 0($t0) # load wait time
	
	li $t0, 10
	mult $t0, $t4 # 10 * wait time
	mflo $t9 # store product in $t9
	
	add $t9, $t9, $t3 # fame + the product ( 10 * wait time)
	# c2 weight stored in $t9
	
	# $t1 has c1 fame
	# $t2 has c1 wait time
	
	# $t3 has c2 fame
	# $t4 has c2 wait time
	
	# compare
	
	blt $t8, $t9, c1_less_c2 # c1 < c2 -> return -1
	bgt $t8, $t9, c1_greater_c2 # c1 > c2 -> return 1
	
	# otherwise weights are equal so check fame directly
	blt $t1, $t3, c1_less_c2
	bgt $t1, $t3, c1_greater_c2
	
	# otherwise return 0 ( exactly the same)
	li $v0, 0
	jr $ra
	
	c1_less_c2:
		li $v0, -1
		jr $ra
		
	c1_greater_c2:
		li $v0, 1
		jr $ra

# Part II
init_queue:
	# $a0 has ptr to queue 
	# $a1 has max_size, number of customers
	
	blez $a1, invalid_max_size
	j valid_max_size
	
	invalid_max_size:
		li $v0, -1
		jr $ra
		
	valid_max_size:
	
	li $t0, 4
	# each customer takes up 8 bytes. loop from 0 to max_size * 8.
	li $t1, 8
	mul $t2, $t1, $a1 # $t2 = max_size * 8
	move $t3, $a0 # use $t3 as ptr to queue
	li $t4, 0 # value to store
	
	# set size to 0 
	sh $t4, 0($t3)
	addi $t3, $t3, 2
	
	# set max_size to $a1
	sh $a1, 0($t3)
	addi $t3, $t3, 2
	
	 for_init_queue:
	 	beq $t0, $t2, for_init_queue_done
	 	
	 	sb $t4, 0($t3)
	 	addi $t3, $t3, 1 # increment queue ptr
	 	
	 	addi $t0, $t0, 1
	 	j for_init_queue
	 	
	  for_init_queue_done: 
	  
	  move $v0, $a1
	  jr $ra

# Part III
memcpy:
	# $a0 has address to copy bytes from
	# $a1 has address to move bytes to
	# $a2 has number of bytes to copy
	
	blez $a2, invalid_byte_buffer
	j valid_byte_buffer
	
	invalid_byte_buffer:
		li $v0, -1
		jr $ra
		
	valid_byte_buffer:
	
	move $t0, $a0 # use $t0 as ptr to source
	move $t1, $a1 # use $t1 as ptr to destination
	
	li $t2, 0
	# $a2 has number of bytes to copy
	
	for_memcpy:
		beq $t2, $a2, for_memcpy_done
		
		lb $t3, 0($t0) # load char from source into $t3
		sb $t3, 0($t1) # store char in destination
		
		addi $t0, $t0, 1
		addi $t1, $t1, 1
		addi $t2, $t2, 1
		
		j for_memcpy
	for_memcpy_done:
	
	move $v0, $a2
	jr $ra

# Part IV
contains:
	# $a0 has the queue, could be empty.
	# $a1 has the ID of the customer we wanna find.
	
	li $t0, 1 # Current level
	li $t1, 1 # max number of nodes in current level ( multiply by 3 when you hit the end )
	li $t2, 0 # number of nodes looked at in current level
	
	li $t3, 0 # keep track of number of customers looked at.
	lb $t4, 0($a0) # current number of customers
	
	move $t5, $a0 # use $t5 as pointer to queue
	addi $t5, $t5, 4 # look past size and max_size
	
	beqz $t4, contains_empty_queue
	j contains_non_empty_queue
	
	contains_empty_queue:
		li $v0, -1
		jr $ra
	
	contains_non_empty_queue:
	
	for_contains:
		beq $t3, $t4, for_contains_done # if we've looked at all the customers we're done.
		
		beq $t2, $t1, for_contains_level_finished # finished looking at this level.
		j for_contains_check_next_struct
		
		for_contains_level_finished:
			li $t2, 0 # reset # of nodes looked at in a level
			addi $t0, $t0, 1 # look at next level
			li $t8, 3 
			mul $t1, $t1, $t8 # multiply # of nodes in a level by 3 every successive level.
			
			# let this fall through since we need to check the next struct anyways.
			
		for_contains_check_next_struct:
			lw $t6, 0($t5) # load ID of current customer
			beq $t6, $a1, contains_present
			
			addi $t5, $t5, 8 # look at next customer
			addi $t2, $t2, 1 # increment # of nodes looked at on this level
			addi $t3, $t3, 1 # increment # of nodes looked at in general
			
			j for_contains
			
	for_contains_done:
	
	j contains_not_present
	
	contains_present:
		move $v0, $t0
		jr $ra
		
	contains_not_present:
		li $v0, -1
		jr $ra
jr $ra

# Part V
enqueue:
jr $ra

# Part VI
heapify_down:
jr $ra

# Part VII
dequeue:
jr $ra

# Part VIII
build_heap:
jr $ra

# Part IX
increment_time:
jr $ra

# Part X
admit_customers:
jr $ra

# Part XI
seat_customers:
jr $ra

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
