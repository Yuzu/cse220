# Timothy Wu
# TIMWU
# 112550028

.data
# Command-line arguments
num_args: .word 0
addr_arg0: .word 0
addr_arg1: .word 0
addr_arg2: .word 0
addr_arg3: .word 0
addr_arg4: .word 0
no_args: .asciiz "You must provide at least one command-line argument.\n"

# Error messages
invalid_operation_error: .asciiz "INVALID_OPERATION\n"
invalid_args_error: .asciiz "INVALID_ARGS\n"

# Put your additional .data declarations here

space: .asciiz " "
newline: .asciiz "\n"
neg_sign: .asciiz "-"

# Main program starts here
.text
.globl main
main:
    # Do not modify any of the code before the label named "start_coding_here"
    # Begin: save command-line arguments to main memory
    sw $a0, num_args
    beqz $a0, zero_args
    li $t0, 1
    beq $a0, $t0, one_arg
    li $t0, 2
    beq $a0, $t0, two_args
    li $t0, 3
    beq $a0, $t0, three_args
    li $t0, 4
    beq $a0, $t0, four_args
five_args:
    lw $t0, 16($a1)
    sw $t0, addr_arg4
four_args:
    lw $t0, 12($a1)
    sw $t0, addr_arg3
three_args:
    lw $t0, 8($a1)
    sw $t0, addr_arg2
two_args:
    lw $t0, 4($a1)
    sw $t0, addr_arg1
one_arg:
    lw $t0, 0($a1)
    sw $t0, addr_arg0
    j start_coding_here

zero_args:
    la $a0, no_args
    li $v0, 4
    syscall
    j exit
    # End: save command-line arguments to main memory

start_coding_here:
    # Start the assignment by writing your code here
    
    # registers $s0-5 should not be touched
    
    lw $s0, addr_arg0 # Load the 1st argument's address into $s0
    lw $s1, addr_arg1 # 2nd arg
    lw $s2, addr_arg2 # 3rd
    lw $s3, addr_arg3 # 4th
    lw $s4, addr_arg4 # 5th
    
    lbu $t1, 0($s0) # Load the 1st character of the argument into $t1
    lbu $t2, 1($s0) # Load the 2nd character of the argument into $t2
    
    # Check whether the argument is of valid length 
    beq $t2, $0,  valid_length # If $t2 contains 0, that means that the argument has terminated ( 0 = null terminator)
    
    # Skipped, unless the arg's 2nd character isn't a null terminator
    li $v0, 4 
    la $a0, invalid_operation_error # Print error
    syscall
    	
    li $v0, 10 #Exit program
    syscall
     
    valid_length:
    
    # Switch statement that compares $t1 to various immediates to ensure either B, C, D, or E was passed.
    # After the switch statement runs, $s5 will be storing the operation (B, C, D, E), of which can be referred to later.
    
    checkB:
    	li $s5, 66 # "B" = 66 in ascii
    	bne $t1, $s5, checkC
    	j valid_operation
    
    checkC:
    	li $s5, 67 # "C" = 67 in ascii
    	bne $t1, $s5, checkD
    	j valid_operation
    	
    checkD:
    	li $s5, 68 # "D" = 68 in ascii
    	bne $t1, $s5, checkE
    	j valid_operation
    
    checkE:
    	li $s5, 69 # "E" = 69 in ascii
    	bne $t1, $s5, invalid_operation
    	j valid_operation
    
    invalid_operation:
    	li $v0, 4 
    	la $a0, invalid_operation_error # Print error
    	syscall
    	
    	li $v0, 10 #Exit program
   	syscall
   	
    valid_operation:
    
    
    # Switch statement to check whether a valid number of arguments have been passed for the given operation (Stored in $s5)
    # Need to ensure that every operation doesn't have extra arguments or too few
    # The line below this checks for a 2nd arg that every operation needs, thus why caseB and caseD don't need to check again for too few arguments.
    
    beq $s1, $0, invalid_num_args # If 2nd arg doesn't exist, jump to default (every operation needs an extra arg)
    
    caseB: # One additional arg expected
    	li $t3, 66
    	bne $s5, $t3, caseC # operation isn't B
    	bne $s2, $0, invalid_num_args # If 3rd arg exists, jump to default (extra arg)
    	
    	j valid_num_args
    	 
    caseC: # Three additional
    	li $t3, 67
    	bne $s5, $t3, caseD # operation isn't C
    	bne $s4, $0, invalid_num_args # 5th arg exists (extra arg)
    	beq $s2, $0, invalid_num_args # 3rd arg doesn't exist (missing args)

    	j valid_num_args
    	
    caseD: # One additional
    	li $t3, 68
    	bne $s5, $t3, caseE # operation isn't D
    	bne $s2, $0, invalid_num_args # 3rd arg exists (extra arg)
    	
    	j valid_num_args
    	
    caseE: # Four additional
	# No need to compare $s5 to anything here, previous switch statement caught any invalid operations.
	# Cannot check past the max number of args
	beq $s2, $0, invalid_num_args # 3rd arg doesn't exist (missing args)
	
    	j valid_num_args
    	
    invalid_num_args:
    	li $v0, 4 
    	la $a0, invalid_args_error # Print error
    	syscall
    	
    	li $v0, 10 #Exit program
   	syscall
    
    valid_num_args:
    
    # Determines which operation to perform
    
    runB:
        li $t3, 66 # 66 is "B"
    	bne $s5, $t3, runC
    	
    	j exit
    	
    runC:
    	li $t3, 67 # 67 is "C"
    	bne $s5, $t3, runD
    	
    	li $s4, 49 # 49 is "1" in ascii
    	li $s5, 50 # "2" in ascii
    	li $s7, 83 # "S" in ascii
    	
    	lbu $t3, 0($s1) # source format
    	lbu $t4 0($s2) # destination format
    	
    	# Validate source format
    	
    	beq $t3, $s4, valid_source_format
    	beq $t3, $s5, valid_source_format
    	beq $t3, $s7, valid_source_format
    	
    	j invalid_source_format
    	
    	invalid_source_format:
    	
    		li $v0, 4
    		la $a0, invalid_args_error
    		syscall
    		
    		li $v0, 10
    		syscall
    	
    	valid_source_format:
    	
    	# Validate destination format
    	beq $t3, $s4, valid_destination_format
    	beq $t3, $s5, valid_destination_format
    	beq $t3, $s7, valid_destination_format
    	
    	j invalid_destination_format
    	
    	invalid_destination_format:
    	
    		li $v0, 4
    		la $a0, invalid_args_error
    		syscall
    		
    		li $v0, 10
    		syscall
    	
    	valid_destination_format:
    	
    	# convert hex to binary

    	addi $s3, $s3, 2 # offset to account for 0x
    	
    	li $t6, 57 # 57 is "9" in ascii
    	li $t0, 65 #65 is "A" in ascii
    	
    	
    	# CHECK SIGN BIT
    	
    	lbu $t1, 0($s3) # Load 1st char
    	
	# Converts the ascii to decimal
	ble $t1, $t6, sign_digits_1 # Less than/equal to 9 means dealing w/ a digit
	bge $t1, $t0, sign_letters_1 # Greater than/equal to A means dealing w/ a letter
	
	# 1-9: subtract 48 from ascii value to get decimal value
	sign_digits_1:
		addi $t1, $t1, -48 # get decimal value
		j sign_digit_1_done

    	 #A-F: subtract 55 from ascii value to get decimal value
	sign_letters_1:
		addi $t1, $t1, -55 # get decimal value
	
	sign_digit_1_done:
	
    	sra $t1, $t1, 3 # Look at sign bit

	li $s6, 0 # Flag for positive integer
	
    	beq $t1, $0, pos_num
    	li $s6, 1# Flag - 1 means negative number
    	
    	pos_num:
    	
	
	# CONVERT CHAR 1
    	
    	lbu $t1, 0($s3) # Load 1st char
    	
	# Converts the ascii to decimal

	ble $t1, $t6, int_digits_1 # Less than/equal to 9 means dealing w/ a digit
	bge $t1, $t0, int_letters_1 # Greater than/equal to A means dealing w/ a letter
	
	# 1-9: subtract 48 from ascii value to get decimal value
	int_digits_1:
		addi $t1, $t1, -48 # get decimal value
		j int_digit_1_done

    	 #A-F: subtract 55 from ascii value to get decimal value
	int_letters_1:
		addi $t1, $t1, -55 # get decimal value
	
	int_digit_1_done:

    	beq $s6, $0, finished_1 # No conversion needed b/c positive rep. same across all formats
    	beq $t3, $t4, finished_1 # Source and destination formats are the same
    	
    	# to/from signed requires a flip, but between ones and twos requires nothing (just add/subtract 1 from last char)
    	# need to keep sign bit after flipping
    	
    	beq $t3, $s7, flip_1
    	beq $t4, $s7, flip_1
    	j finished_1
    	
    	flip_1:
    		not $t1, $t1 # Flip bits
 
    		addi $t1, $t1, 0x8 # Re-add sign bit
    		sll $t1, $t1, 28 # Get rid of extra bits
    		srl $t1, $t1, 28
    	
    	finished_1:
    	
    	li $s0, 0 # Use $s0 as running sum. Initialize it to 0.
    	
    	sll $t1, $t1, 28 # These 4 bits are the msb.
    	
    	add $s0, $s0, $t1 # Increment running sum
    	
    	
    	# CONVERT CHAR 2-7
    	# The conversions for these sandwiched bits are the same. We can use a for loop.
    	
    	li $t8, 28 # "i" in for-loop
    	li $t9, 0 # Converting 6 characters
    	addi $s3, $s3, 1 # Move $s3 to char 2
    	# 28 24(SHIFT) 20(SHIFT) 16 (SHIFT) 12(SHIFT) 8(SHIFT) 4(SHIFT) 0(SHIFT) DON'T NEED 0 SHIFT IS LAST ONE -4(DONE)
    	for_int_conv:
    		blt $t8, $t9, for_int_conv_done
    		addi $t8, $t8, -4
    		
    		lbu $t1, 0($s3) # load current character
    		
    		# Converts the ascii to decimal

		ble $t1, $t6, for_middle_digits # Less than/equal to 9 means dealing w/ a digit
		bge $t1, $t0, for_middle_letters # Greater than/equal to A means dealing w/ a letter
	
		# 1-9: subtract 48 from ascii value to get decimal value
		for_middle_digits:
			addi $t1, $t1, -48 # get decimal value
			j for_middle_digits_done

    	 	#A-F: subtract 55 from ascii value to get decimal value
		for_middle_letters:
			addi $t1, $t1, -55 # get decimal value
	
		for_middle_digits_done:

    		beq $s6, $0, finished_middle_digits # No conversion needed b/c positive rep. same across all formats
    		beq $t3, $t4, finished_middle_digits # Source and destination formats are the same
    	
    		# to/from signed requires a flip, but between ones and twos requires nothing (just add/subtract 1 from last char)
    		# no need to worry about sign bit in these sandwiched bits
    	
    		beq $t3, $s7, flip_middle_digits
    		beq $t4, $s7, flip_middle_digits
    		j finished_middle_digits
    	
    		flip_middle_digits:
    			not $t1, $t1 # Flip bits
 			
 			sllv $t1, $t1, $t8 # Get rid of extra bits ($t8 is the loop control, counts down from 
 			srlv $t1, $t1, $t8
    			sll $t1, $t1, 28 # Get rid of extra bits
    			srl $t1, $t1, 28
    	
    		finished_middle_digits:
    	
    		sll $t1, $t1, 24 # Move bits to proper positions
    	
    		add $s0, $s0, $t1 # Increment running sum
    	
    		
    		for_int_conv_done:
    		#stop here
    	lbu $t1, 1($s3) # Load 2nd char
    	
	# Converts the ascii to decimal

	ble $t1, $t6, int_digits_2 # Less than/equal to 9 means dealing w/ a digit
	bge $t1, $t0, int_letters_2 # Greater than/equal to A means dealing w/ a letter
	
	# 1-9: subtract 48 from ascii value to get decimal value
	int_digits_2:
		addi $t1, $t1, -48 # get decimal value
		j int_digit_2_done

    	 #A-F: subtract 55 from ascii value to get decimal value
	int_letters_2:
		addi $t1, $t1, -55 # get decimal value
	
	int_digit_2_done:

    	beq $s6, $0, finished_2 # No conversion needed b/c positive rep. same across all formats
    	beq $t3, $t4, finished_2 # Source and destination formats are the same
    	
    	# to/from signed requires a flip, but between ones and twos requires nothing (just add/subtract 1 from last char)
    	# no need to worry about sign bit in these sandwiched bits
    	
    	beq $t3, $s7, flip_2
    	beq $t4, $s7, flip_2
    	j finished_2
    	
    	flip_2:
    		not $t1, $t1 # Flip bits
 		
    		sll $t1, $t1, 28 # Get rid of extra bits
    		srl $t1, $t1, 28
    	
    	finished_2:
    	
    	sll $t1, $t1, 24 # Move bits to proper positions
    	
    	add $s0, $s0, $t1 # Increment running sum
    	
    	# CONVERT CHAR 3
    	
    	
    	
    	j exit
    runD:
    	# Check whether we're running D or not
    	li $t3, 68 # c8 is "D"
    	bne $s5, $t3, runE
    	
    	lbu $t4, 10($s1) 
    	bne $t4, $0, invalid_hex_address # Hex address is longer than 10 characters
    	
    	# Ensure first two characters are 0x
    	lbu $t4, 0($s1) # Load 1st char of 2nd arg into $t4
    	li $t5, 48 # 48 is "0" in ascii
    	bne $t4,  $t5, invalid_hex_address
    	
    	addi $s1, $s1, 1 # Load 2nd char of 2nd arg into $t4
    	lbu $t4, 0($s1) 
    	li $t5, 120 # 120 is "x" in ascii
    	bne $t4, $t5, invalid_hex_address
    	
    	li $t1, 0 # "i" in for-loop
    	li $t2, 8  # Upper bound only needs to be 8 since we already checked the first two char
    	
    	li $t5, 48 # 48 is "0" in ascii
    	li $t6, 57 # 57 is "9" in ascii
    	li $t0, 65 #65 is "A" in ascii
    	li $t7, 70 # 70 is "F" in ascii
    	
    	addi $s1, $s1, 1 # Load 3rd char of 2nd arg, already checked first two.
    	
    	for_validation:
    		beq $t1, $t2, valid_hex_address # Check if loop is done
    		addi $t1, $t1, 1 # Increment loop
    		
    		lbu $t4, 0($s1) # Load current char of 2nd arg
    		
    		blt $t4, $t5, invalid_hex_address # Ascii value less than "0" (48)
    		bgt $t4, $t7, invalid_hex_address # Ascii value greater than "F" (70)
    		
    		bgt $t4, $t6, greater_than_57 # Need to make sure we don't miss ascii values between 57 and 65, those are invalid.
    		j valid_char
    		
    		greater_than_57:
			blt $t4, $t0, invalid_hex_address # If the char is in that blind spot between 57 and 65, it's invalid. 57 < char < 65
    		
    	   	valid_char:
    	   	
    	   	addi $s1, $s1, 1 # Increment to next char in string
    	   	j for_validation

    	invalid_hex_address:
    	    	li $v0, 4 
    		la $a0, invalid_args_error # Print error
    		syscall
    	
    		li $v0, 10 #Exit program
   		syscall
    	
    	valid_hex_address:
    	
	# The below will convert the hex to the operation's respective fields
	
	lw $s1, addr_arg1 # reload 2nd arg
	
	addi $s1, $s1, 2 # Offset to 3rd char in 2nd arg b/c don't need to look at first 2
	
	# $t6 is still "9" in ascii, no need to re-assign
    	# $t0 is still "A" in ascii
	
	# OBTAIN OPCODE
	# OPCODE USES: All of char 1 + first 2 bytes of char 2 = 6 total
	
	lbu $t1, 0($s1) # Loads char 1
	
	# Converts the ascii to decimal
	ble $t1, $t6, opcode_digits_1 # Less than/equal to 9 means dealing w/ a digit
	bge $t1, $t0, opcode_letters_1 # Greater than/equal to A means dealing w/ a letter
	
	# 1-9: subtract 48 from ascii value to get decimal value
	opcode_digits_1:
		addi $t1, $t1, -48 # get decimal value
		j opcode_digit_1_done

    	 #A-F: subtract 55 from ascii value to get decimal value
	opcode_letters_1:
		addi $t1, $t1, -55 # get decimal value
	
	opcode_digit_1_done:
	
	
	sll $t1, $t1, 2 # Shift left to make space for the other 2 bits from char 2

	lbu $t2, 1($s1) # Loads char 2
	
	# Converts the ascii to decimal
	ble $t2, $t6, opcode_digits_2 # Less than/equal to 9 means dealing w/ a digit
	bge $t2, $t0, opcode_letters_2 # Greater than/equal to A means dealing w/ a letter
	
	# 1-9: subtract 48 from ascii value to get decimal value
	opcode_digits_2:
		addi $t2, $t2, -48 # get decimal value
		j opcode_digit_2_done

    	 #A-F: subtract 55 from ascii value to get decimal value
	opcode_letters_2:
		addi $t2, $t2, -55 # get decimal value
	
	opcode_digit_2_done:
	
	srl $t2, $t2, 2 #shift right 2 because there's no need for the last 2 bits
	
	add $t3, $t1, $t2 # Combine two values
	
	li $v0, 1
	move $a0, $t3
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	# OBTAIN RS FIELD
	# RS FIELD USES: Last 2 bits of char 2 + first 3 bits of char 3 = 5 total
	
	lbu $t1, 1($s1) # Load char 2
	
	# Converts the ascii to decimal
	ble $t1, $t6, rs_digits_1 # Less than/equal to 9 means dealing w/ a digit
	bge $t1, $t0, rs_letters_1 # Greater than/equal to A means dealing w/ a letter
	# 1-9: subtract 48 from ascii value to get decimal value
	rs_digits_1:
		addi $t1, $t1, -48 # get decimal value
		j rs_digits_done_1

    	 #A-F: subtract 55 from ascii value to get decimal value
	rs_letters_1:
		addi $t1, $t1, -55 # get decimal value
	
	rs_digits_done_1:
	
	andi $t1, $t1, 0x3 # Mask everything except for 2 lsb which is what we need here (sll alone can't get rid of the bits)
	sll $t1, $t1, 3 # Shift left to move bits into msb spots
	
	lbu $t2, 2($s1) # Load char 3
	
	# Converts the ascii to decimal
	ble $t2, $t6, rs_digits_2 # Less than/equal to 9 means dealing w/ a digit
	bge $t2, $t0, rs_letters_2 # Greater than/equal to A means dealing w/ a letter
	
	# 1-9: subtract 48 from ascii value to get decimal value
	rs_digits_2:
		addi $t2, $t2, -48 # get decimal value
		j rs_digits_done_2

    	 #A-F: subtract 55 from ascii value to get decimal value
	rs_letters_2:
		addi $t2, $t2, -55 # get decimal value
	
	rs_digits_done_2:
	
	srl $t2, $t2, 1 # Shift 3rd char right 1 b/c only need first 3 bits
	
	add $t3, $t1, $t2
	
	li $v0, 1
	move $a0, $t3
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	
	# OBTAIN RT FIELD
	# RT FIELD USES: Last bit of char 3 + all of char 4 = 5 bits
	
	lbu $t1, 2($s1) # Load char 3
	
	# Converts the ascii to decimal
	ble $t1, $t6, rt_digits_1 # Less than/equal to 9 means dealing w/ a digit
	bge $t1, $t0, rt_letters_1 # Greater than/equal to A means dealing w/ a letter
	
	# 1-9: subtract 48 from ascii value to get decimal value
	rt_digits_1:
		addi $t1, $t1, -48 # get decimal value
		j rt_digits_done_1

    	 #A-F: subtract 55 from ascii value to get decimal value
	rt_letters_1:
		addi $t1, $t1, -55 # get decimal value
	
	rt_digits_done_1:
	
	andi $t1, $t1, 0x1 # Mask everything but the lsb, which is what we need
	sll $t1, $t1, 4 # Move this bit into the msb spot
	
	lbu $t2, 3($s1) # load char 4
	
	# Converts the ascii to decimal
	ble $t2, $t6, rt_digits_2 # Less than/equal to 9 means dealing w/ a digit
	bge $t2, $t0, rt_letters_2 # Greater than/equal to A means dealing w/ a letter
	
	# 1-9: subtract 48 from ascii value to get decimal value
	rt_digits_2:
		addi $t2, $t2, -48 # get decimal value
		j rt_digits_done_2

    	 #A-F: subtract 55 from ascii value to get decimal value
	rt_letters_2:
		addi $t2, $t2, -55 # get decimal value
	
	rt_digits_done_2:
	
	add $t3, $t1, $t2
	
	li $v0, 1
	move $a0, $t3
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	
	# OBTAIN IMMEDIATE FIELD
	 
	 # CHAR 5
	 
	 lbu $t2, 4($s1) # load char 5 HERE
	
	# Converts the ascii to decimal
	ble $t2, $t6, imm_digits_1 # Less than/equal to 9 means dealing w/ a digit
	bge $t2, $t0, imm_letters_1 # Greater than/equal to A means dealing w/ a letter
	
	# 1-9: subtract 48 from ascii value to get decimal value
	imm_digits_1:
		addi $t2, $t2, -48 # get decimal value
		j imm_digits_done_1

    	 #A-F: subtract 55 from ascii value to get decimal value
	imm_letters_1:
		addi $t2, $t2, -55 # get decimal value
	
	imm_digits_done_1:
	
	move $s6, $t2 # copy $t2 into $s6 for checking, don't want to edit $t2.
	srl $s6, $s6, 3 # move 3 bits over to the right, the remaining bit should be the sign bit.
	 
	bne $s6, $0, flip_bits_1 # If we're dealing with a negative number, we need to flip all the bits and add 1 (two's complement to decimal)
	
	li $s6, 0 # We'll refer back to $s6 to tell whether we need to flip the later bits. 0 = pos number, no flip, 1 = neg number, flip 
	j final_1 # Jump over bit flips
	
	flip_bits_1:
		li $s6, 1 # Flag for negative number we'll refer to later on.
		not $t2, $t2 # Flip bits
		sll $t2, $t2, 28 # Get rid of the other bits, we only need the least significant 4.
		srl $t2, $t2, 28
		# Don't add 1 until the end.
	
	final_1:

	sll $t2, $t2, 12 # move 3 bytes b/c these are the MSBs
	li $t3, 0 # Initialize $t3 to 0, ensure no garbage memory messes it up
	add $t3, $0, $t2 # $t3 will serve as a running sum.
	
	# CHAR 6
	
	lbu $t2 5($s1) # load char 6
	
	# Converts the ascii to decimal
	ble $t2, $t6, imm_digits_2 # Less than/equal to 9 means dealing w/ a digit
	bge $t2, $t0, imm_letters_2 # Greater than/equal to A means dealing w/ a letter
	
	# 1-9: subtract 48 from ascii value to get decimal value
	imm_digits_2:
		addi $t2, $t2, -48 # get decimal value
		j imm_digits_done_2

    	 #A-F: subtract 55 from ascii value to get decimal value
	imm_letters_2:
		addi $t2, $t2, -55 # get decimal value
	
	imm_digits_done_2:
	
	bne $s6, $0, flip_bits_2 # $s6 != 0 means neg number therefore we need to flip
	j final_2
	flip_bits_2:
		not $t2, $t2
		sll $t2, $t2, 28 # Get rid of the other bits, we only need the least significant 4.
		srl $t2, $t2, 28
	final_2:
	
	sll $t2, $t2, 8 # move 2 bytes
	
	add $t3, $t3, $t2 # add to running sum
	
	# CHAR 7
	
	lbu $t2, 6($s1) # load 7th character
	
	# Converts the ascii to decimal
	ble $t2, $t6, imm_digits_3 # Less than/equal to 9 means dealing w/ a digit
	bge $t2, $t0, imm_letters_3 # Greater than/equal to A means dealing w/ a letter
	
	# 1-9: subtract 48 from ascii value to get decimal value
	imm_digits_3:
		addi $t2, $t2, -48 # get decimal value
		j imm_digits_done_3

    	 #A-F: subtract 55 from ascii value to get decimal value
	imm_letters_3:
		addi $t2, $t2, -55 # get decimal value
	
	imm_digits_done_3:
	
	bne $s6, $0, flip_bits_3 # $s6 != 0 means neg number therefore we need to flip
	j final_3
	flip_bits_3:
		not $t2, $t2
		sll $t2, $t2, 28 # Get rid of the other bits, we only need the least significant 4.
		srl $t2, $t2, 28
	final_3:
	sll $t2, $t2, 4 # move 1 byte
	
	add $t3, $t3, $t2 # add to running sum
	

	# CHAR 8 ( LAST CHAR, INCREMENT HERE)

	lbu $t2, 7($s1) # load 8th character
	
	# Converts the ascii to decimal
	ble $t2, $t6, imm_digits_4 # Less than/equal to 9 means dealing w/ a digit
	bge $t2, $t0, imm_letters_4 # Greater than/equal to A means dealing w/ a letter
	
	# 1-9: subtract 48 from ascii value to get decimal value
	imm_digits_4:
		addi $t2, $t2, -48 # get decimal value
		j imm_digits_done_4

    	 #A-F: subtract 55 from ascii value to get decimal value
	imm_letters_4:
		addi $t2, $t2, -55 # get decimal value
	
	imm_digits_done_4:
	
	bne $s6, $0, flip_bits_4 # $s6 != 0 means neg number therefore we need to flip
	j final_4
	flip_bits_4:
		not $t2, $t2
		sll $t2, $t2, 28 # Get rid of the other bits, we only need the least significant 4.
		srl $t2, $t2, 28
		addi $t2, $t2, 1 # Last set of bits, need to increment if flipping.
	final_4:
	
	# No shift needed
	
	add $t3, $t3, $t2 # add to running sum
	
	bne $s6, $0, print_neg_sign # neg number, need to print negative sign
	j print_digits
	
	print_neg_sign:
		li $v0, 4
		la $a0, neg_sign
		syscall
	
	print_digits:
		li $v0, 1
		move $a0, $t3
		syscall
	
		li $v0, 4
		la $a0, newline
		syscall
	
    	j exit


    runE:
	
	li $s6, 0 # Initialize $s6 as a running sum to 0.
    	li $t0, 10 # Need to multiply tens place for proper value
    	
    	# VALIDATE & CONVERT 2ND ARGUMENT
    	
    	lw $t1, addr_arg1 # Load 2nd arg
	
	lbu $t2, 0($t1) # $t2 = tens place digit
	lbu $t3, 1($t1) # $t3 = one's place digit

	andi $t2,$t2,0x0F # Mask to convert ascii to decimal digit
	andi $t3,$t3,0x0F
	
	mul $t2, $t2, $t0 # Need to multiply digit in 10s place by 10.
	
	add $t4, $t2, $t3 # Store the decimal value of the digit in $t4
	
    	# arg 2 must be in range [0, 63] INCLUSIVE
    	li $t1, 63 # Ok to overwrite $t1, don't need it for this arg anymore
    	bltz $t4, invalid_arg_ranges # Less than 0 
    	bgt $t4, $t1, invalid_arg_ranges # Greater than 63
    	
    	sll $t4, $t4, 26 # these 6 bits are the msb
    	add $s6, $0, $t4 # Add $t4 into $s6, which stores the running sum.
  
  
    	# VALIDATE AND CONVERT 3RD ARGUMENT
    	
    	lw $t1, addr_arg2
    	
    	lbu $t2, 0($t1) # $t2 = tens place digit
	lbu $t3, 1($t1) # $t3 = one's place digit

	andi $t2,$t2,0x0F # Mask to convert ascii to decimal digit
	andi $t3,$t3,0x0F
	
	mul $t2, $t2, $t0 # Need to multiply digit in 10s place by 10.
	
	add $t4, $t2, $t3 # Store the decimal value of the digit in $t4
	
    	# arg 3 must be in range [0, 31]
    	li $t1, 31
    	bltz $t4, invalid_arg_ranges
    	bgt $t4, $t1, invalid_arg_ranges
    	
    	sll $t4, $t4, 21 # shift into proper locations
    	add $s6, $s6, $t4 # Add $t4 into $s6, which stores the running sum.
    	

	# VALIDATE AND CONVERT 4TH ARGUMENT
	
	lw $t1, addr_arg3
	
    	lbu $t2, 0($t1) # $t2 = tens place digit
	lbu $t3, 1($t1) # $t3 = one's place digit

	andi $t2,$t2,0x0F # Mask to convert ascii to decimal digit
	andi $t3,$t3,0x0F
	
	mul $t2, $t2, $t0 # Need to multiply digit in 10s place by 10.
	
	add $t4, $t2, $t3 # Store the decimal value of the digit in $t4
	
    	# arg 4 must be in range [0, 31]
    	li $t1, 31
    	bltz $t4, invalid_arg_ranges
    	bgt $t4, $t1, invalid_arg_ranges
    	
    	sll $t4, $t4, 16 # shift into proper locations
    
    	add $s6, $s6, $t4 # Add $t4 into $s6, which stores the running sum.
    	
    	
    	# VALIDATE AND CONVERT 5TH ARGUMENT
    	
    	lw $t1, addr_arg4
    	li $t0, 45 # Overwrite $t0 with ascii 45 = "-" (neg sign)
    	lbu $t2, 0($t1)
    	
    	li $s7, 0  # Flag variable to indicate a positive number.
    	
    	beq $t2, $t0, neg_flag # Branch if the first character is a negative sign
    	j pos_flag
    	
    	neg_flag:
    		li $s7, 1 # Flag set to 1 to indicate a negative number
    		addi $t1, $t1, 1 # Offset the char by 1 so that 0($t1) will get the first digit instead of the negative sign.
    	
    	pos_flag:
    	li $t4, 0  # Ensure $t4 has nothing in it.
    	
    	# TEN-THOUSANDS PLACE
    	lbu $t2, 0($t1) # re-load 1st digit (in case neg flag was triggered)
    	li $t0, 10000

    	andi $t2,$t2,0x0F # Mask to convert ascii to decimal digit
	mul $t2, $t2, $t0 # Need to multiply digit in ten-thousands place by ten-thousand
	add $t4, $t2, $0 # Store the decimal value of the digit in $t4

    	# THOUSANDS PLACE
    	lbu $t2, 1($t1)
    	li $t0, 1000
    	
    	andi $t2,$t2,0x0F # Mask to convert ascii to decimal digit
	mul $t2, $t2, $t0 # Need to multiply digit in thousands place by 1000
	add $t4, $t4, $t2 # Add to running sum
	
	# HUNDREDS PLACE
	lbu $t2, 2($t1)
	li $t0, 100
	
	andi $t2,$t2,0x0F # Mask to convert ascii to decimal digit
	mul $t2, $t2, $t0 # Need to multiply digit in hundreds place by 100
	add $t4, $t4, $t2 # Add to running sum

	# TENS PLACE
	lbu $t2, 3($t1)
	li $t0, 10
	
	andi $t2, $t2, 0x0F # Mask to convert ascii to decimal digit
	mul $t2, $t2, $t0
    	add $t4, $t4, $t2 # Add to running sum
    	
    	# ONES PLACE
    	lbu $t2, 4($t1)
    	
    	andi $t2, $t2, 0x0F # Mask to convert to digit
    	add $t4, $t4, $t2  # Add to running sum
    	
	move $t5, $t4 # We'll keep the two's comp. representation in $t4, and use the unsigned ver. in $t5 to compare absolute value to validate the range.
	
	# FLIP IF NEGATIVE
	
	beq $s7, $0, no_flip # If $s7 = 0, we're dealing w/ a positive number.
	
	not $t4, $t4 # Flip bits
	sll $t4, $t4, 16 # Get rid of the other bits, we only need the least significant 16.
	srl $t4, $t4, 16 # Shift back
	addi $t4, $t4, 1 # Increment by 1 for two's comp representation
	
	no_flip:
	
    	# arg 5 must be in range [-2^15, 2^(15) - 1]
    	li $t0 32768
    	li $t1, 32767
    	
    	beq $s7, $0, positive # Branch if $s7 = 0 which means pos number
    	
    	bgt $t5, $t0, invalid_arg_ranges # Absolute value greater
    	
    	positive:
    	
    	bgt $t5, $t1, invalid_arg_ranges
    	
    	j valid_arg_ranges
    	
    	invalid_arg_ranges:
    	
    		li $v0, 4 
    		la $a0, invalid_args_error # Print error
    		syscall
    	
    		li $v0, 10 #Exit program
   		syscall
   		
    	valid_arg_ranges:
    	
	add $s6, $s6, $t4
    	
    	li $v0, 34
    	move $a0, $s6
    	syscall
    	
    	li $v0, 4
    	la $a0, newline
    	syscall
    	
    	j exit
    

    
    
    
    
    	

    
    


exit:
    li $v0, 10
    syscall
