
playerprint: .asciiz "player"
newline: .asciiz "\n"

# print out players.
li $t6, 0
lw $t7, num_players
la $t8, players

for_print_players:
	beq $t6, $t7, for_print_players_done
	
	li $v0, 4
	la $a0, newline
	syscall
	
	li $v0, 4
	la $a0, playerprint
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	lw $t0, 0($t8) # load list address into $t0
	lw $t1, 4($t0) # load head address into $t1.
	beqz $t1, for_print_player_done
	for_print_player:
		lw $t2, 0($t1) # load node's num into $t2
	
		# print node's num
		li $v0, 34
		move $a0, $t2
		syscall
	
		# print newline
		li $v0, 4
		la $a0, newline
		syscall
	
		lw $t2, 4($t1) # load address of next node
	
		beqz $t2, for_print_player_done # null terminator
		# else we continue
		move $t1, $t2
		j for_print_player
	
	for_print_player_done:
	addi $t8, $t8, 4 # look at next player
	addi $t6, $t6, 1 
	j for_print_players
	
for_print_players_done: