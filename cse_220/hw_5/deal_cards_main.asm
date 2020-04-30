.data
num_players: .word 4
cards_per_player: .word 3

.align 2
deck:
.word 20  # list's size
.word node23692 # address of list's head
node77535:
.word 5453636
.word node90434
node28240:
.word 4405060
.word node31215
node40511:
.word 5453380
.word node24494
node31215:
.word 4475460
.word node4008
node18062:
.word 5456196
.word node71368
node90434:
.word 4478020
.word node3094
node60404:
.word 4407620
.word node18062
node4008:
.word 4403780
.word node16180
node23692:
.word 5452612
.word node50879
node24494:
.word 4410180
.word node58270
node21888:
.word 4471108
.word 0
node16180:
.word 5452868
.word node60404
node3094:
.word 4732228
.word node21888
node58270:
.word 4404292
.word node42602
node50879:
.word 4404036
.word node28240
node24884:
.word 4732996
.word node83356
node42602:
.word 4475716
.word node24884
node25303:
.word 5452356
.word node77535
node83356:
.word 5460292
.word node25303
node71368:
.word 4732740
.word node40511

player1: .word 0 0
.word 6984629  # random garbage
.word 5132219  # random garbage
.word 2990259  # random garbage
.word 1588699  # random garbage
.word 1081975  # random garbage
player2: .word 0 0
.word 1911766  # random garbage
.word 5133787  # random garbage
.word 9782283  # random garbage
.word 8620252  # random garbage
.word 6807150  # random garbage
player0: .word 0 0
.word 7039142  # random garbage
.word 1353081  # random garbage
.word 9307555  # random garbage
.word 6374046  # random garbage
.word 8794063  # random garbage
player3: .word 0 0
.word 8437237  # random garbage
.word 1677497  # random garbage
.word 6544662  # random garbage
players: .word player0 player1 player2 player3

.text
.globl main
main:
la $a0, deck
la $a1, players
lw $a2, num_players
lw $a3, cards_per_player
jal deal_cards

# Write your own code here to verify that the function is correct.

li $v0, 10
syscall

.include "proj5.asm"
