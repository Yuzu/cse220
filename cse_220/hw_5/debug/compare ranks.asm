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
	
	both_greater_than_9:
	
	card_one_max:
	li $v0, -1
	jr $ra
	
	card_two_max:
	li $v0, 1
	jr $ra
	
	card_tie:
	# for our purposes, there will never be a rank comparison between different suits, and decks will have no dupes, but it's nice to have this.
	li $v0, 0
	jr $ra