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
	
	beqz $t1, build_heap_empty_queue
	j build_heap_non_empty_queue
	
	build_heap_empty_queue:
		li $v0, 0
		lw $s0, 0($sp)
		lw $s2, 4($sp)
		addi $sp, $sp, 8
		jr $ra
	
	build_heap_non_empty_queue:
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
	# $a0 has the queue
	# $a1 has max customers to admit
	# $a2 has an unintialized array of structs.
	
	# use $s0 as counter in for-loop and to keep track of number of admits.
	# use $s1 as ptr to our array.
	# use $s2 to keep track of queue size.
	# $a1 will remain as our for-loop upper bound
	
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	blez $a1, admit_customers_invalid_args
	# load queue size.
	lh $s2, 0($a0)
	beqz $s2, admit_customers_invalid_args
	j admit_customers_valid_args
	
	admit_customers_invalid_args:
		li $v0, -1
		
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		addi $sp, $sp, 12
		
		jr $ra
	
	admit_customers_valid_args:
	
	li $s0, 0
	move $s1, $a2

	for_admit_customers:
		beq $s0, $a1, for_admit_customers_done # we've hit max # of customers to admit.
		beqz $s2 for_admit_customers_done # we've hit the end of the queue.
		
		# preserve args for dequeue call
		addi $sp, $sp, -16
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)
		sw $ra, 12($sp)
		
		# queue still in $a0
		# a1 needs ptr to cust struct, we'll use the stack for that.
		addi $sp, $sp, -8 # make space for the customer struct
		move $fp, $sp # use fp to point to the customer struct.
		move $a1, $fp
		
		jal dequeue
		
		move $fp, $a1
		addi $sp, $sp, 8 # look past cust struct
		
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $ra, 12($sp)
		addi $sp, $sp, 16
		
		# write customer to the array w/ memcpy.
		
		addi $sp, $sp, -16
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)
		sw $ra, 12($sp)
		
		move $a0, $fp # $a0 needs src, which is $fp
		move $a1, $s1 # $a1 needs the destination, which is the admitted array.
		li $a2, 8 # write 8 bytes at most
		
		jal memcpy
		
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $ra, 12($sp)
		addi $sp, $sp, 16
		
		addi $s0, $s0, 1
		addi $s1, $s1, 8 # store in next spot.
		# load queue size.
		lh $s2, 0($a0)
		j for_admit_customers
		
	for_admit_customers_done:
	
	move $v0, $s0
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	
	# restore fp
	move $fp, $sp
	
	jr $ra

# Part XI
seat_customers:
	# $a0 has admitted array
	# $a1 has len of admitted array
	# $a2 has budget, max amount of wait time.
	
	# initialize every value to 1 on the stack unless their weight is strictly greater than the budget. We'll pick which ones to not seat from there.
	# use $s0 to keep track of weight sum.
	# $s1 to keep track of max's weight.
	# $s2 = maximizing space's index 0 wait time.
	
	blez $a1, seat_customers_invalid_args
	blez $a2, seat_customers_invalid_args
	j seat_customers_valid_args
	
	seat_customers_invalid_args:
		li $v0, -1
		li $v1, -1
		jr $ra
	
	seat_customers_valid_args:
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	li $t0, 0
	move $t1, $a0 # use $t1 as ptr to admitted array
	for_seat_customers_init:
		beq $t0, $a1, for_seat_customers_init_done
		
		lh $t8, 6($t1) # load customer wait time (weight).
		
		bgt $t8, $a2, for_seat_customers_init_no_chance
		j for_seat_customers_init_chance
		
		for_seat_customers_init_no_chance: # their weight is strictly greater than the budget, no way they'll be admitted.
			li $t2, 0
			j for_seat_customers_init_store_bit
			
		for_seat_customers_init_chance:
			li $t2, 1
		
		for_seat_customers_init_store_bit:
		# store 1 or 0 in the stack.
		addi $sp, $sp, -4
		sw $t2, 0($sp)
		
		addi $t0, $t0, 1
		addi $t1, $t1, 8 # look at next struct.
		j for_seat_customers_init
		
	for_seat_customers_init_done:
	
	# 0($sp) is the last elem of the array.
	
	# loop through admitted array, if the customer status = 1 then we add its weight to a running sum and compare to budget.
	# if the sum > budget, we loop through again to calculate ratios via  fame / weight. we want higher numbers so we keep track of the min, and after we finish looping, we set the lowest to 0 to not give them a seat. 
	# run back to top of loop and keep doing until sum <= budget.
	
	for_seat_customers_main:
	li $t0, 0 # keep track of the index we're at.
	# $a1 has len of admitted array so we use that to control the loop.
	move $t1, $a0 # use $t1 as ptr to admitted array.
	li $t2, 0 # use $t2 as running sum of wait times.
	move $fp, $sp # use $fp to check stack and determine whether we're including the current customer or not.
	# fp is "backwards" so we need to add 4 * len-1 and then keep subtracting 4 from fp.
	
	li $t8, 4
	mul $t8, $t8, $a1 # 4 * len
	addi $t8, $t8, -4 # don't wanna change $a1 so we just subtract 4 here to basically make it 4 * len - 1.
	add $fp, $fp, $t8
	
	for_seat_customers_calculate_weights:
		beq $t0, $a1, for_seat_customers_calculate_weights_done
		
		lw $t5, 0($fp) # load status of current customer. 
		beqz $t5, for_seat_customers_calculate_weights_continue # if status is 0 then we're not admitting them so we continue. otherwise we add the customer's weight.
		
		lh $t3, 6($t1) # load customer wait time into $t3
		add $t2, $t2, $t3 # add wait time to running sum.
		
		
		for_seat_customers_calculate_weights_continue:
		addi $t0, $t0, 1
		addi $fp, $fp, -4 # look at next customer's status.
		addi $t1, $t1, 8 # look at next struct
		
		j for_seat_customers_calculate_weights
		
	for_seat_customers_calculate_weights_done:
	
	move $fp, $sp # restore $fp
	
	ble $t2, $a2, seat_customers_reduction_done # if the total weights <= budget then we've reduced as much as possible.
	
	li $t0, 1 # keep track of the index we're at. we start at index 1 b/c we're gonna calculate the ratio of index 0 before the loop even starts.
	# $a1 has len of admitted array so we use that to control the loop.
	move $t1, $a0 # use $t1 as ptr to admitted array.
	
	li $t2, 0 # use $t2 as the index w/ the minimum ratio. defaults to the 1st index.
	li $t3, 0 # use $t3 as the actual ratio value of said minimum ratio.
	
	lh $t4, 4($t1) # load customer fame into $t4
	lh $t5, 6($t1) # load customer wait_time into $t5
	div $t4, $t5 # calculate ratio = fame / weight
	
	mflo $t3 # move ratio to $t3
	addi $t1, $t1, 8 # look at next struct.
	
	# fp is "backwards" so we need to add 4 * len-1 and then keep subtracting 4 from fp.
	
	li $t8, 4
	mul $t8, $t8, $a1 # 4 * len
	addi $t8, $t8, -4 # don't wanna change $a1 so we just subtract 4 here to basically make it 4 * len - 1.
	add $fp, $fp, $t8
	addi $fp, $fp, -4 # we already looked at the first elem.
	
	for_seat_customers_reduce:
		beq $t0, $a1, for_seat_customers_reduce_done
		
		# check customer status, if they're 0 we don't care. if 1 then we need to check if it's min or not.
		lw $t8, 0($fp) # load status of current customer. 
		bnez $t8, for_seat_customers_reduce_non_zero # if status is non-zero then we wanna check if it's min or not.
		# otherwise, status is 0 so we don't care. jump to continue.
		j for_seat_customers_reduce_continue
		
		for_seat_customers_reduce_non_zero:
		lh $t4, 4($t1) # load customer fame into $t4
		lh $t5, 6($t1) # load customer wait_time into $t5
		
		beqz $t5, for_seat_customers_reduce_continue # if wait time is 0, the divison will yield a 0 but including them is free real estate so we don't consider it as a min.
		# calculate ratio = fame / weight
		div $t4, $t5
		mflo $t6 # store current struct's ratio in $t6
		
		blt $t6, $t3, for_seat_customers_reduce_new_min # if current struct's ratio is less than the min's ratio then we've found a new min.
		beq $t6, $t3, for_seat_customers_reduce_equal_mins # if the ratios are equal, we need to compare fame. 
		j for_seat_customers_reduce_continue # otherwise we increment and continue.
		
		for_seat_customers_reduce_equal_mins:
			# compare current customer's fame to min's fame.
			
			# current customer's fame is stored in $t4 right now.
			# min's fame isn't stored, but we have the index in $t2 so we can find it.
			
			move $t9, $a0 # use $t9 as ptr to admitted array.
			li $t8, 8 
			mul $t8, $t8, $t2 # 8 * index = the offset.
			
			add $t9, $t9, $t8 # add offset
			
			lh $t7, 4($t9) # store min's fame in $t7.
			
			# if current's fame is less or equal, we have a new min. otherwise, we continue.
			blt $t4, $t7, for_seat_customers_reduce_new_min
			# otherwise we continue.
			j for_seat_customers_reduce_continue
			
		for_seat_customers_reduce_new_min:
			move $t2, $t0 # current index is the new min
			move $t3, $t6 # current index's ratio moved to $t3.
			# fall through b/c we still need to continue on.
			
		for_seat_customers_reduce_continue:
		addi $t0, $t0, 1 # look at next index
		addi $t1, $t1, 8 # look at next struct.
		addi $fp, $fp, -4 # look at next customer's status.
		j for_seat_customers_reduce
		
	for_seat_customers_reduce_done:
	# we now have the index of the struct w/ the lowest ratio in $t2. we need to set that one to 0 on the stack. At this point the only $t register we need is $t2. can overwrite all the others.
	
	# use $fp to get there.
	move $fp, $sp
	
	# fp is "backwards" so we need to add 4 * len-1 and then keep subtracting 4 from fp.
	li $t8, 4
	mul $t8, $t8, $a1 # 4 * len
	addi $t8, $t8, -4 # don't wanna change $a1 so we just subtract 4 here to basically make it 4 * len - 1.
	add $fp, $fp, $t8
	
	li $t0, 0 # going to store 0.
	li $t1, -4 # multiply by -4 to get to the struct on the stack
	mul $t3, $t1, $t2 # 4 * min index = address offset for the index we wanna find on the stack, stored in $t3.
	
	add $fp, $fp, $t3 # add offset
	sw $t0, 0($fp) # store 0 in the spot.
	
	move $fp, $sp # restore $fp
	
	# loop back to recalculate weights and see if that was enough of a change.
	j for_seat_customers_main
	
	seat_customers_reduction_done:
	
	move $s0, $t2 # store current sum of weights in $s0.
	
	seat_customers_maximum_reduction:
	
	beq $s0, $a2, seat_customers_create_bytestring # can't possibly add any more if we're at the max limit.
	
	# look at the 0's. if they can be safely re-added, calculate their ratios and then add the max. 
	
	li $t0, 1 # keep track of the index we're at. we start at index 1 b/c we're gonna calculate the ratio of index 0 before the loop even starts.
	# $a1 has len of admitted array so we use that to control the loop.
	move $t1, $a0 # use $t1 as ptr to admitted array.
	
	li $t2, 0 # use $t2 as the index w/ the maximum ratio. defaults to the 1st index.
	li $t3, 0 # use $t3 as the actual ratio value of said maximum ratio.
	
	lh $t4, 4($t1) # load customer fame into $t4
	lh $t5, 6($t1) # load customer wait_time into $t5
	div $t4, $t5 # calculate ratio = fame / weight
	
	move $s2, $t5 # store index 0 wait time in $s2
	
	mflo $t3 # move ratio to $t3
	addi $t1, $t1, 8 # look at next struct.
	
	# fp is "backwards" so we need to add 4 * len-1 and then keep subtracting 4 from fp.
	move $fp, $sp # restore $fp
	li $t8, 4
	mul $t8, $t8, $a1 # 4 * len
	addi $t8, $t8, -4 # don't wanna change $a1 so we just subtract 4 here to basically make it 4 * len - 1.
	add $fp, $fp, $t8
	addi $fp, $fp, -4 # we already looked at the first elem.
	
	for_seat_customers_maximize_space:
		beq $t0, $a1, for_seat_customers_maximize_space_done
		
		# check customer status, if they're 1, we don't care. we only want to see if we can re-add the maximum 0's without going over the limit.
		lw $t8, 0($fp)
		beqz $t8, for_seat_customers_maximize_space_zero
		# otherwise status is 1 so we don't care. jump to continue.
		j for_seat_customers_maximize_space_continue
		
		for_seat_customers_maximize_space_zero:
			lh $t4, 4($t1) # load fame
			lh $t5, 6($t1) # load wait time
			
			beqz $t5, for_seat_customers_maximize_space_continue # if wait time is 0, the divison will yield a 0 but including them is free real estate so we don't consider it.
			# add wait time to current sum, if it goes over the limit, we can't consider this one, so just continue.
			add $t6, $s0, $t5 
			bgt $t6, $a2, for_seat_customers_maximize_space_continue
			
			# calculate ratio = fame / weight
			div $t4, $t5
			mflo $t6 # store current struct's ratio in $t6
			
			bgt $t6, $t3, for_seat_customers_maximize_space_new_max # if current struct's ratio is greater than the max's, we;'ve found a new max.
			beq $t6, $t3, for_seat_customers_maximize_space_equal_maxes # if the ratios are equal, we need to compare fame.
			
			# if max is still 0, we need to check the following:
			beqz $t2, for_seat_customers_maximize_space_check_zero_index_against_current
			j for_seat_customers_maximize_space_continue # otherwise continue.
			# there's a chance our 0 index is invalid ( too much weight), but this one is guaranteed to be valid. if 0 index is invalid, this is automatically the new max.
			# add index 0 wait time ( stored in $s2) to the current weights. if it goes over, the current index is the new max by default.
			for_seat_customers_maximize_space_check_zero_index_against_current:
				add $t7, $s0, $s2
				bgt $t7, $a2, for_seat_customers_maximize_space_new_max
				j for_seat_customers_maximize_space_continue
			
			for_seat_customers_maximize_space_equal_maxes:
				# compare current customer fame to max's fame.
				
				# current customer's fame is sotred in $t4 rn
				# max's fame isn't stored, but we have the index in $t2 so we can find it.
			
				move $t9, $a0 # use $t9 as ptr to admitted array.
				li $t8, 8 
				mul $t8, $t8, $t2 # 8 * index = the offset.
			
				add $t9, $t9, $t8 # add offset
			
				lh $t7, 4($t9) # store max's fame in $t7.
				
				# if current's fame is greater or equal, we have a new max. otherwise, we continue.
				bgt $t4, $t7, for_seat_customers_maximize_space_new_max
				# otherwise we continue.
				j for_seat_customers_maximize_space_continue
				
				for_seat_customers_maximize_space_new_max:
				move $t2, $t0 # current index is the new max
				move $t3, $t6 # current index's ratio moved to $t3.
				move $s1, $t5 # store wait time in $s1
				# fall through b/c we still need to continue on.
				
			for_seat_customers_maximize_space_continue:
			addi $t0, $t0, 1 # look at next index
			addi $t1, $t1, 8 # look at next struct.
			addi $fp, $fp, -4 # look at next customer's status.
			j for_seat_customers_maximize_space
			
	for_seat_customers_maximize_space_done:
	
	# we now have the index of the struct w/ the highest ratio  that doesn't send us over the limit in $t2. we need to set that one to 1 on the stack. At this point the only $t register we need is $t2. can overwrite all the others.
	
	# if our 0 index is the max, that means the weights of all the other 0 entries are a nogo.
	# but, there's a chance that this 0 index is actually a 1 (already admitted).
	# so, we check if 0 index is admitted or not. if they're admitted, we just jump to return.
	# otherwise, we need to check if their weight is valid. add index 0 wait time ( stored in $s2) to the current weights. if it goes over, there's nothing more we can add and jump to return.
	# if index 0 is both un-admitted and has a valid weight, we continue by adding them.
	
	move $fp, $sp # restore $fp
	lw $t9, 0($fp) # load 0 index.
	bnez $t9, seat_customers_create_bytestring
	
	beqz $t2, for_seat_customers_maximize_space_check_zero_index
	j for_seat_customers_maximize_space_update_stack
	
	for_seat_customers_maximize_space_check_zero_index:
		add $t6, $s0, $s2
		bgt $t6, $a2, seat_customers_create_bytestring
	
	for_seat_customers_maximize_space_update_stack:
	
	# use $fp to get there.
	move $fp, $sp
	
	# fp is "backwards" so we need to add 4 * len-1 and then keep subtracting 4 from fp.
	li $t8, 4
	mul $t8, $t8, $a1 # 4 * len
	addi $t8, $t8, -4 # don't wanna change $a1 so we just subtract 4 here to basically make it 4 * len - 1. 
	add $fp, $fp, $t8
	
	li $t0, 1 # going to store 1.
	li $t1, -4 # multiply by -4 to get to the struct on the stack
	mul $t3, $t1, $t2 # 4 * min index = address offset for the index we wanna find on the stack, stored in $t3.
	
	add $fp, $fp, $t3 # add offset
	sw $t0, 0($fp) # store 0 in the spot.
	
	move $fp, $sp # restore $fp
	
	# get the new weight and if it's <= we loop back over.
	add $s0, $s0, $s1
	
	blt $s0, $a2, seat_customers_maximum_reduction
	# otherwise we fall through and return.
	
	seat_customers_create_bytestring:

	li $t0, 0 # "i" in for-loop, used in sllv.
	# $a1 used for upper-bound of loop.
	move $t1, $a0 # use $t1 as ptr to admitted array.
	
	li $t5, 0 # used as running sum of fames.
	
	li $t9, 0 # use $t9 as the bytestring to return.
	
	# traversing $fp backwards so we need to traverse the queue backwards too and subtract 8 for every struct. Get to end of queue by using 8 * queue size - 1 and adding that.
	
	li $t8, 8 
	mul $t8, $t8, $a1 # $t8 = 8 * queue size
	addi $t8, $t8, -8 # don't wanna change $a1 so we just subtract 4 here to basically make it 8 * len - 1. AGAIN I DON'T KNOW WHY BUT I GIVE UP.
	add $t1, $t1, $t8
	
	for_seat_customers_create_bytestring:
		beq $t0, $a1, for_seat_customers_create_bytestring_done
		lw $t8, 0($fp) # load status of current customer.
		
		beqz $t8, for_seat_customers_create_bytestring_not_seated # if status = 0, we don't wanna include their fame in the return value.
		# otherwise we need to load their fame and add it to the return value.
		lh $t4, 4($t1) # load fame of customer
		add $t5, $t5, $t4 # add fame to running sum.
		
		for_seat_customers_create_bytestring_not_seated:
		
		add $t9, $t9, $t8
		sll $t9, $t9, 1 # shift $t9 left by 1 bit
		
		#addi $fp, $fp, -4 # look at next customer's status HEREEEEEEEEEEEE
		addi $fp, $fp, 4
		addi $t1, $t1, -8 # look at next customer struct
		addi $t0, $t0, 1 # increment i
		
		j for_seat_customers_create_bytestring
	
	
	for_seat_customers_create_bytestring_done:
	srl $t9, $t9, 1 # shift by 1 to account for the first number we put in that didn't need a shift.
	move $v0, $t9
	move $v1, $t5
	
	# restore the stack space we used during the function call.
	
	li $t0, 0 
	# upper bound is $a1
	for_seat_customers_restore_stack:
		beq $t0, $a1, for_seat_customers_restore_stack_done
		addi $sp, $sp, 4
		addi $t0, $t0, 1
		j for_seat_customers_restore_stack
		
	for_seat_customers_restore_stack_done:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	
	jr $ra

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
