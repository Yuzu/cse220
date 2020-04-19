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
	li $t0, 0
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

# Part V
enqueue:
	# $a0 has the queue
	# $a1 has a ptr to the customer to queue
	
	# $s0 used to store the inserted node we're looking at
	# $s1 used to store the inserted node's current parent node.
	
	# $s2 has the inserted node's address
	# $s3 has the inserted node's parent's address
	
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	
	lh $t0, 0($a0) # load current size
	lh $t1, 2($a0) # load max-size
	
	beq $t0, $t1, enqueue_invalid_insertion
	# otherwise check if customer is already in the queue.
	lw $t0, 0($a1) # Load customer ID
	
	# Preserve args
	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $ra, 8($sp)
	
	# $a0 still has queue
	move $a1, $t0 # move customer ID to check for
	jal contains
	
	# restore args
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	
	bgez $v0, enqueue_invalid_insertion # function returns -1 if the customer ID doesn't exist in the queue. we want that.
	j enqueue_valid_insertion
	
	enqueue_invalid_insertion:
		
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		addi $sp, $sp, 16
		
		li $v0, -1
		lb $v1, 0($a0)
		jr $ra
	
	enqueue_valid_insertion:
	
	# insert elem at bottom most level, leftmost position ( first empty spot in array)
	
	move $t0, $a0 # use $t0 as ptr to queue.
	
	lh $t1, 0($t0) # load current queue size.
	li $t2, 8 
	mul $t1, $t1, $t2 # find insertion spot for customer
	
	addi $t0, $t0, 4 # look past size and max size
	add $t0, $t0, $t1
	# $t0 now has the correct insertion spot.
	
	# Preserve args
	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $ra, 8($sp)
	
	move $a0, $a1 # $a1 has the address to copy from
	move $a1, $t0 # $t0 is the address to copy bytes to
	li $a2, 8 # write 8 bytes at most.
	
	jal memcpy
	
	# restore args
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	
	# look at node's parent. the current index of the inserted node is size (because we haven't incremented after inserting yet).
	# parent node is current index / 3 (integer division). 
	
	lh $s0, 0($a0) # load index of inserted node into $s0

	li $s2, 0
	li $s3, 0
	
	for_enqueue_swap:
		move $t0, $a0 # use $t0 as ptr to queue.
		addi $t0, $t0, 4 # look past size and max_size
		
		li $t1, 3
		div $s0, $t1 # inserted node / 3
		
		mflo $s1 # store parent index in $s1
		
		# compare weights of the two nodes.
		
		li $t8, 8 # mult by 8 to get address offset.
		
		mul $t2, $s0, $t8 # store inserted offset in $t2
		mul $t3, $s1, $t8 # store parent offset in $t3
		addi $t2, $t2, 4 # ignore queue dimensions
		addi $t3, $t3, 4 
		
		# store inserted node's address in $s2
		move $s2, $a0
		add $s2, $s2, $t2
		
		# store parent's address in $s3
		
		move $s3, $a0
		add $s3, $s3, $t3
		
		
		addi $sp, $sp, -12
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $ra, 8($sp)
		
		move $a0, $s2
		move $a1, $s3
		
		jal compare_to
		
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $ra, 8($sp)
		addi $sp, $sp, 12
		
		# if inserted > parent, return value will be 1.
		bgtz $v0, enqueue_swap_needed
		
		# no swap means node is in the correct position, and we're done.
		j for_enqueue_swap_done
		
		enqueue_swap_needed:
			# need to swap the two nodes.
			# copy parent node to current address, but that means inserted node is overwritten, so -> (next line)
			# copy $a1 ( has customer struct) the parent address.
			
			
			# Copy parent node to inserted node's address.
			addi $sp, $sp, -12
			sw $a0, 0($sp)
			sw $a1, 4($sp)
			sw $ra, 8($sp)
			
			move $a0, $s3 # source address = $s3
			move $a1, $s2 # destination address = $s2
			li $a2, 8
			
			jal memcpy
			
			lw $a0, 0($sp)
			lw $a1, 4($sp)
			lw $ra, 8($sp)
			addi $sp, $sp, 12
			
			# write inserted node to parent address.
			addi $sp, $sp, -12
			sw $a0, 0($sp)
			sw $a1, 4($sp)
			sw $ra, 8($sp)
			
			move $a0, $a1 # source address = $a1
			move $a1, $s3 # destination address = $s3
			li $a2, 8
			
			jal memcpy
			
			lw $a0, 0($sp)
			lw $a1, 4($sp)
			lw $ra, 8($sp)
			addi $sp, $sp, 12
			
			# inserted node index and address is what was previously it's parent's.
			move $s0, $s1
			move $s2, $s3
			
			# next runthrough will recalculate the parent values, but check break condition first.
			beqz $s1, for_enqueue_swap_done # when parent index = 0 we've hit the top of the heap.
			j for_enqueue_swap
		
		
	for_enqueue_swap_done:
	
	lb $t0, 0($a0) # load current size of queue
	addi $t0, $t0, 1 # increment
	sb $t0, 0($a0) # update queue size
	
	li $v0, 1
	move $v1, $t0
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16
	jr $ra

# Part VI
heapify_down:
	# $s0 has index
	# $s1 has queue size
	
	# $s2 has current index (left/mid/right)
	# $s3 has current address (left/mid/right)
	
	# $s4 has largest index
	# $s5 has largest address
	
	# $s6 used to keep track of return value.
	
	addi $sp, $sp, -28
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	
	bltz $a1, heapify_down_invalid_args
	
	lh $s1, 0($a0) # look at the queue size
	bge $a1, $s1, heapify_down_invalid_args
	j heapify_down_valid_args
	
	heapify_down_invalid_args:
		li $v0, -1
		
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $s6, 24($sp)
		addi $sp, $sp, 28
		
		jr $ra
		
	heapify_down_valid_args:
	
	
	move $s0, $a1 # store index in $s0
	# $s1 has queue size
	
	move $t0, $a0 # use $t0 as ptr to queue
	
	# $s0 has index
	# $s1 has queue size
	
	# $s2 has current index (left/mid/right)
	# $s3 has current address (left/mid/right)
	
	# $s4 has largest index
	# $s5 has largest address
	
	# $s6 used to keep track of return value.
	
	
	li $s6, 0
	while_heapify_down:
		bge $s0, $s1, while_heapify_down_done
		
		# calculate left index = 3 * index + 1 and store in $s2
		li $t9, 3
		
		mul $s2, $s0, $t9 # index * 3, stored in $s2
		addi $s2, $s2, 1
		
		# calculate left address and store in $s3
		
		move $t0, $a0 # reset queue ptr
		addi $t0, $t0, 4 # look past dimensions
		li $t9, 8
		mul $s3, $s2, $t9 # multiply left index by 8
		add $s3, $s3, $t0 # store left address in $s3
		
		# largest = index, store it in $s4
		move $s4, $s0
		
		# calculate largest address and store in $s5
		move $t0, $a0 # reset queue ptr
		addi $t0, $t0, 4 # look past dimensions
		
		li $t9, 8
		mul $t5, $s4, $t9 # find address offset of largest index
		add $s5, $t0, $t5 # set address of largest to $s5
		
		bge $s2, $s1, while_heapify_down_not_left
			# if A[left] > A[largest] then largest = left
			
			# call compare_to 
			addi $sp, $sp, -12
			sw $a0, 0($sp)
			sw $a1, 4($sp)
			sw $ra, 8($sp)
			
			move $a0, $s3 # left
			move $a1, $s5 # largest
			
			jal compare_to
			
			lw $a0, 0($sp)
			lw $a1, 4($sp)
			lw $ra, 8($sp)
			addi $sp, $sp, 12
			
			blez $v0, while_heapify_down_not_left
				# otherwise return value of 1 means that we have a new max, set largest = left.
				move $s4, $s2
				move $s5, $s3
				
		while_heapify_down_not_left:
		# calculate mid = 3 * index + 2 and store in $s2
		li $t9, 3
		mul $s2, $s0, $t9
		addi $s2, $s2, 2
		
		# calculate mid address and store in $s3
		move $t0, $a0 # reset queue ptr
		addi $t0, $t0, 4 # look past dimensions
		li $t9, 8
		mul $s3, $s2, $t9 # multiply mid index by 8
		add $s3, $s3, $t0 # store mid address in $s3
		

		bge $s2, $s1, while_heapify_down_not_mid
		# if A[mid] > A[largest] then largest = mid
			
			# call compare_to 
			addi $sp, $sp, -12
			sw $a0, 0($sp)
			sw $a1, 4($sp)
			sw $ra, 8($sp)
			
			move $a0, $s3 # mid
			move $a1, $s5 # largest
			
			jal compare_to
			
			lw $a0, 0($sp)
			lw $a1, 4($sp)
			lw $ra, 8($sp)
			addi $sp, $sp, 12
			
			blez $v0, while_heapify_down_not_mid
				# otherwise return value of 1 means that we have a new max, set largest = mid
				move $s4, $s2
				move $s5, $s3
				
		while_heapify_down_not_mid:
		# calculate right = 3 * index + 3 and store in $s2
		li $t9, 3
		mul $s2, $s0, $t9
		addi $s2, $s2, 3
		
		# calculate right address and store in $s3
		move $t0, $a0 # reset queue ptr
		addi $t0, $t0, 4 # look past dimensions
		li $t9, 8
		mul $s3, $s2, $t9 # multiply right index by 8
		add $s3, $s3, $t0 # store right address in $s3
		
		 bge $s2, $s1, while_heapify_down_check_largest
		 # if A[right] > A[largest] then largest = right
		 
		 # call compare_to 
			addi $sp, $sp, -12
			sw $a0, 0($sp)
			sw $a1, 4($sp)
			sw $ra, 8($sp)
			
			move $a0, $s3 # right
			move $a1, $s5 # largest
			
			jal compare_to
			
			lw $a0, 0($sp)
			lw $a1, 4($sp)
			lw $ra, 8($sp)
			addi $sp, $sp, 12
			
			blez $v0, while_heapify_down_check_largest
				# otherwise return value of 1 means that we have a new max, set largest = mid
				move $s4, $s2
				move $s5, $s3
		 
		 while_heapify_down_check_largest:
		 
		 beq $s4, $s0, while_heapify_down_done
		 # otherwise, largest != index
		 
		 # swap A[index] and A[largest]
		 
		 # find A[index] address and store in $s3
		move $t0, $a0 # reset queue ptr
		addi $t0, $t0, 4 # look past dimensions
		li $t9, 8
		mul $s3, $s0, $t9 # multiply index by 8
		add $s3, $s3, $t0 # store address in $s3
		
		# address of largest already in $s5.
		
		# preserve args
		addi $sp, $sp, -12
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $ra, 8($sp)
		
		# store values of largest on stack
		addi $sp, $sp, -8
		move $fp, $sp # use $fp as arg for second memcpy call.
		
		lw $t0, 0($s5) # load customer ID
		lh $t1, 4($s5) # load customer fame
		lh $t2, 6($s5) # load customer wait_time
		
		sw $t0, 0($fp) # store args
		sh $t1, 4($fp)
		sh $t2, 6($fp)
		
		# write index -> largest w/ memcpy
		
		move $a0, $s3 # write from index address
		move $a1, $s5 # write to largest address
		li $a2, 8 # write 8 bytes.
		
		jal memcpy
		
		addi $sp, $sp, 8 # look past the value stored on stack
		
		# restore args
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $ra, 8($sp)
		addi $sp, $sp, 12
		
		# fp still points to the customer we pushed on the stack.
		
		# write largest -> index
		
		# preserve args
		addi $sp, $sp, -12
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $ra, 8($sp)
		
		move $a0, $fp # write from largest address ( on stack currently)
		move $a1, $s3 # write to index address ( still in $s3)
		li $a2, 8 
		
		jal memcpy
		
		# restore args
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $ra, 8($sp)
		addi $sp, $sp, 12
		
		 # set index = largest and loop over.
		move $s0, $s4
		addi $s6, $s6, 1 # increment number of swaps
		j while_heapify_down
		
	while_heapify_down_done:
	
	move $v0, $s6
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	addi $sp, $sp, 28
	move $fp, $sp
	jr $ra
	
# Part VII
dequeue:
	# $a0 has queue
	# $a1 has dequeued_customer
	
	# check if queue is empty
	
	lh $t0, 0($a0)
	beqz $t0, dequeue_empty_queue
	j dequeue_non_empty_queue
	
	dequeue_empty_queue:
		li $v0, -1
		jr $ra
		
	dequeue_non_empty_queue:
	
	# copy head of heap into $a1 using memcpy
	
	# preserve args
	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $ra, 8($sp)
	
	move $t0, $a0 # use $t0 as ptr to queue
	addi $t0, $t0, 4 # look at 1st queue elem
	move $a0, $t0 # $a0 needs src address, head of heap.
	# $a1 needs destination address ( still in $a1 from the dequeue function call)
	li $a2, 8 # write 8 bytes
	
	jal memcpy
	
	# restore args
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	
	# copy last elem of heap into head.
	
	move $t0, $a0 # use $t0 as ptr to queue
	addi $t1, $t0, 4 # store address of head of heap in $t1
	
	 move $t0, $a0 # use $t0 as ptr to queue
	 lh $t2, 0($t0) # get queue size in $t2
	 addi $t2, $t2, -1
	 li $t8, 8 
	 
	 mul $t2, $t2, $t8 # queue size * 8 = address offset of last elem in $t2
	 addi $t2, $t2, 4
	 add $t2, $t0, $t2 # add offset to queue address, $t2 has address of last elem.
	 
	 # call memcpy to copy last elem to head.
	 
	 # preserve args
	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $ra, 8($sp)
	
	move $a0, $t2 # $a0 needs src address, last heap elem stored in $t2
	move $a1, $t1 # $a1 needs destination address, the head of the heap stored in $t1
	li $a2, 8 # write 8 bytes
	
	jal memcpy
	
	# restore args
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	
	# decrement queue size.
	
	move $t0, $a0 # use $t0 as ptr to queue
	lh $t1, 0($t0) # get queue size in $t1
	addi $t1, $t1, -1
	sh $t1, 0($t0) # store new queue size.
	
	# call heapify_down on index 0.
	
	# preserve args
	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $ra, 8($sp)
	
	# $a0 needs queue, still there.
	li $a1, 0 # $a1 needs starting index, start at index 0.
	
	jal heapify_down
	
	# restore args
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	
	move $t0, $a0 # use $t0 as ptr to queue
	lh $t1, 0($t0) # get queue size in $t1
	move $v0, $t1 # set return value
	
	jr $ra

# Part VIII
build_heap:
	# $a0 has queue
	
	# $s0 used to store res
	# $s2 used to store index, same as i. 
	
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $s2, 4($sp)
	
	li $s0, 0 # res = 0
	li $s2, 0
	
	li $t0, 3
	lh $t1, 0($a0) # get queue size in $t1
	
	# index = (queue size - 1) / 3 : integer division
	add $s2, $s2, $t1
	addi $s2, $s2, -1 
	div $s2, $t0
	mflo $s2
	
	for_build_heap:
		bltz $s2, for_build_heap_done
		
		# call heapify_down
		
		# preserve args
		addi $sp, $sp, -12
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $ra, 8($sp)
		
		# $a0 still has queue
		move $a1, $s2 # index is "i".
		
		jal heapify_down
		
		# restore args
		
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $ra, 8($sp)
		addi $sp, $sp, 12
		
		add $s0, $s0, $v0 # add return value to res
		
		addi $s2, $s2, -1
		
		j for_build_heap
		
	for_build_heap_done:
	
	move $v0, $s0
	
	
	lw $s0, 0($sp)
	lw $s2, 4($sp)
	addi $sp, $sp, 8
	jr $ra

# Part IX
increment_time:
	# $a0 has ptr to queue
	# $a1 has delta_mins
	# $a2 has fame_level
	
	# loop through queue and increment wait time of everyone by delta_mins
	# also check fame, if fame is < fame_level we wanna add delta_mins to their fame.
	
	move $t0, $a0 # use $t0 as ptr to queue
	
	lh $t1, 0($t0) # load current queue size into $t1, we're gonna loop from 0 to that.
	beqz $t1, increment_time_invalid_args
	blez $a1, increment_time_invalid_args
	blez $a2, increment_time_invalid_args
	j increment_time_valid_args
	
	increment_time_invalid_args:
		li $v0, -1
		jr $ra
	
	increment_time_valid_args:
	li $t2, 0 # "i" in for-loop
	
	addi $t0, $t0, 4 # look past dimensions
	for_increment_time:
		beq $t2, $t1, for_increment_time_done
		
		lh $t3, 6($t0) # load wait_time into $t3
		add $t3, $t3, $a1 # increment wait time by delta_mins
		sh $t3, 6($t0) # store new wait_time 
		
		lh $t3, 4($t0) # load fame into $t3
		bge $t3, $a2, for_increment_time_only
		# otherwise fame < fame_level so we add delta_mins to the fame.
		add $t3, $t3, $a1
		sh $t3, 4($t0)
		for_increment_time_only:
		
		# look at next struct and loop over.
		addi $t0, $t0, 8
		addi $t2, $t2, 1
		j for_increment_time
		
	for_increment_time_done:
	
	# call build_heap.
	
	# preserve args
	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $ra, 8($sp)
	
	jal build_heap
	
	# restore args
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	
	# calculate avg wait time now.
	
	move $t0, $a0 # use $t0 as ptr to queue
	
	lh $t1, 0($t0) # load current queue size into $t1, we're gonna loop from 0 to that.
	li $t2, 0 # "i" in for-loop
	
	addi $t0, $t0, 4 # look past dimensions
	
	li $t5, 0 # running sum of wait times.
	# divide by $t1 at the end.
	
	for_increment_time_get_averages:
		beq $t2, $t1, for_increment_time_get_averages_done
		
		lh $t3, 6($t0) # load wait_time into $t3
		
		add $t5, $t5, $t3 # add wait time to $t5
		
		# look at next struct and loop over.
		addi $t0, $t0, 8
		addi $t2, $t2, 1
		j for_increment_time_get_averages
		
	for_increment_time_get_averages_done:
	div $t5, $t1
	mflo $v0
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
