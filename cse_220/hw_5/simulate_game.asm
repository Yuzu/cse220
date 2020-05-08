.data

num_rounds: .word 8

.align 2

deck:
.word 52
.word node0
node0:
.word 4412484
.word node1
node1:
.word 4470340
.word node2
node2:
.word 4731716
.word node3
node3:
.word 4469572
.word node4
node4:
.word 4732740
.word node5
node5:
.word 5456196
.word node6
node6:
.word 4470084
.word node7
node7:
.word 5452356
.word node8
node8:
.word 5460292
.word node9
node9:
.word 5452868
.word node10
node10:
.word 4410180
.word node11
node11:
.word 4405572
.word node12
node12:
.word 4469316
.word node13
node13:
.word 5453636
.word node14
node14:
.word 5453380
.word node15
node15:
.word 4409924
.word node16
node16:
.word 4732228
.word node17
node17:
.word 4732484
.word node18
node18:
.word 4731972
.word node19
node19:
.word 4403780
.word node20
node20:
.word 4411716
.word node21
node21:
.word 5453892
.word node22
node22:
.word 5452612
.word node23
node23:
.word 4407620
.word node24
node24:
.word 4404036
.word node25
node25:
.word 4405060
.word node26
node26:
.word 4478020
.word node27
node27:
.word 4737860
.word node28
node28:
.word 5453124
.word node29
node29:
.word 4405316
.word node30
node30:
.word 4470596
.word node31
node31:
.word 5461060
.word node32
node32:
.word 4731460
.word node33
node33:
.word 4470852
.word node34
node34:
.word 4404804
.word node35
node35:
.word 4404548
.word node36
node36:
.word 4469828
.word node37
node37:
.word 5454148
.word node38
node38:
.word 4477252
.word node39
node39:
.word 4732996
.word node40
node40:
.word 4475460
.word node41
node41:
.word 4739396
.word node42
node42:
.word 4733252
.word node43
node43:
.word 4475716
.word node44
node44:
.word 4473156
.word node45
node45:
.word 4735300
.word node46
node46:
.word 5458756
.word node47
node47:
.word 4740164
.word node48
node48:
.word 4471108
.word node49
node49:
.word 4404292
.word node50
node50:
.word 5458500
.word node51
node51:
.word 4737604
.word 0


player2: .word 0x123 0x456 # random garbage
.word 945484  # random garbage
.word 7887685  # random garbage
player1: .word 0x123 0x456 # random garbage
.word 8167798  # random garbage
.word 9447533  # random garbage
.word 7261285  # random garbage
.word 5285886  # random garbage
.word 3350436  # random garbage
player3: .word 0x123 0x456 # random garbage
.word 7182577  # random garbage
.word 4260696  # random garbage
.word 4761240  # random garbage
player0: .word 0x123 0x456 # random garbage
.word 3030677  # random garbage
.word 7543622  # random garbage
.word 4050312  # random garbage
.word 3670542  # random garbage

players: .word player0 player1 player2 player3 

.text
.globl main
main:
la $a0, deck
la $a1, players
lw $a2, num_rounds
li $s0 -420
li $s1 -420
li $s2 -420
li $s3 -420
li $s4 -420
li $s5 -420
li $s6 -420
li $s7 -420


jal simulate_game

# Write your own code here to verify that the function is correct.
move $t0, $v0

li $v0, 34
move $a0, $t0
syscall

li $v0, 10
syscall

.include "proj5.asm"
