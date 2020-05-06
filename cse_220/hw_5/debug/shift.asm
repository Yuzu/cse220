.data

num: .word 4403780



.text
.globl main

main:
	lw $t0, num
	
	# convert face down to face up
	#addi $t0, $t0, 17 
	
	# shift right by 2 bytes, only remaining value is the suit.
	#srl $t0, $t0, 16 
	
	# shift left by 3 bytes and 3 to the right, only remaining value is the orientation of the card.
	#sll $t0, $t0, 24
	#srl $t0, $t0, 24
	
	# shift left by 2 bytes and 3 to the right, only remaining value is the card rank.
	#sll $t0, $t0, 16
	#srl $t0, $t0, 24
	sw $t0, num
