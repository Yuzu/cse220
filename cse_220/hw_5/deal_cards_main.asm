.data

num_players: .word 6
cards_per_player: .word 5
.align 2
deck:
.word 27  # list's size
.word node69403 # address of list's head
node27546:
.word 4404036
.word node28967
node17126:
.word 4411716
.word node43898
node19587:
.word 4403780
.word node19267
node46225:
.word 4407620
.word node67037
node37599:
.word 4405060
.word node31356
node55780:
.word 5452612
.word node58491
node90679:
.word 5452868
.word node62663
node74703:
.word 4731460
.word node77266
node64902:
.word 4410180
.word node22052
node19267:
.word 4731716
.word 0
node77266:
.word 5453124
.word node43894
node31356:
.word 4469316
.word node46225
node98969:
.word 5453380
.word node5153
node85146:
.word 4404548
.word node98969
node62663:
.word 4475716
.word node55780
node45462:
.word 4475460
.word node12809
node43894:
.word 4412484
.word node48338
node67037:
.word 4469828
.word node27546
node69403:
.word 5456196
.word node64902
node5153:
.word 4737604
.word node37599
node43898:
.word 4740164
.word node74703
node12809:
.word 4732484
.word node19587
node22052:
.word 4735300
.word node85146
node88665:
.word 4470340
.word node45462
node28967:
.word 4473156
.word node17126
node48338:
.word 4477252
.word node90679
node58491:
.word 5454148
.word node88665

player4: .word 0 0
.word 9995023  # random garbage
.word 6323351  # random garbage
player1: .word 0 0
.word 644700  # random garbage
.word 2356651  # random garbage
.word 6614725  # random garbage
player2: .word 0 0
.word 4359925  # random garbage
.word 9207000  # random garbage
.word 6515902  # random garbage
.word 6766545  # random garbage
player0: .word 0 0
.word 4750650  # random garbage
.word 9966965  # random garbage
.word 2560442  # random garbage
.word 9956418  # random garbage
player3: .word 0 0
.word 231042  # random garbage
.word 8832921  # random garbage
.word 4250024  # random garbage
.word 6113547  # random garbage
.word 4192239  # random garbage
player5: .word 0 0
.word 2357333  # random garbage
.word 7662870  # random garbage
.word 307866  # random garbage
.word 8213376  # random garbage
.word 5204763  # random garbage

players: .word player0 player1 player2 player3 player4 player5 

newline: .asciiz "\n"
deckprint: .asciiz "deck"
playerprint: .asciiz "player"

.text
.globl main
main:
la $a0, deck
la $a1, players
lw $a2, num_players
lw $a3, cards_per_player

li $s0 -420
li $s1 -420
li $s2 -420
li $s3 -420
li $s4 -420
li $s5 -420
li $s6 -420
li $s7 -420


jal deal_cards

# Write your own code here to verify that the function is correct.
move $t0, $v0
# print return value.
li $v0, 1
move $a0, $t0
syscall

li $v0, 4
la $a0, newline
syscall

la $t0, deck # load list address into $t0

lw $t1, 0($t0) # load list size into $t1 

# print list size
li $v0, 1
move $a0, $t1
syscall

li $v0, 4
la $a0, newline
syscall

li $v0, 4
la $a0, newline
syscall

li $v0, 4
la $a0, deckprint
syscall

li $v0, 4
la $a0, newline
syscall

la $t0, deck # load list address into $t0
lw $t1, 4($t0) # load head address into $t1.
beqz $t1, for_print_LL_done
for_print_LL:
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
	
	beqz $t2, for_print_LL_done # null terminator
	# else we continue
	move $t1, $t2
	j for_print_LL
	
for_print_LL_done:

li $v0, 4
la $a0, newline
syscall


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
	

li $v0, 10
syscall

.include "proj5.asm"
