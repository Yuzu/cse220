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
    
    
    
    

    
    
    
    
    	

    
    


exit:
    li $v0, 10
    syscall
