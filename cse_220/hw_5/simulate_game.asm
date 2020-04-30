.data
num_rounds: .word 5

.align 2
deck:
.word 52  # list's size
.word node6864 # address of list's head
node58763:
.word 5454148
.word node13375
node34777:
.word 4470340
.word node61512
node78329:
.word 5458500
.word node49493
node27114:
.word 4404036
.word node79811
node34938:
.word 4469316
.word node14117
node4817:
.word 4411716
.word node39990
node62512:
.word 4731716
.word node34777
node70282:
.word 4412484
.word node73705
node41348:
.word 4404804
.word node95950
node39990:
.word 5453380
.word node45019
node5001:
.word 4473156
.word node49693
node35085:
.word 4731972
.word node11428
node73705:
.word 5453892
.word node43542
node17703:
.word 4731460
.word node44200
node18636:
.word 4740164
.word node16548
node95950:
.word 5453124
.word node58763
node61512:
.word 4409924
.word node4817
node6864:
.word 4405316
.word node35085
node68377:
.word 4478020
.word node63303
node56445:
.word 5452612
.word node75158
node43752:
.word 4403780
.word node91972
node38248:
.word 4732484
.word node56445
node14117:
.word 4475460
.word node5001
node49493:
.word 5452868
.word node9159
node45019:
.word 4469828
.word node68377
node44200:
.word 4737604
.word node73527
node57184:
.word 4470084
.word node11484
node79811:
.word 5456196
.word node83724
node91972:
.word 4732228
.word node32135
node32135:
.word 4732996
.word node21467
node44670:
.word 4469572
.word node6803
node13375:
.word 5460292
.word node5753
node16548:
.word 4404548
.word node2784
node9159:
.word 4737860
.word node865
node49693:
.word 4477252
.word node70282
node21467:
.word 5453636
.word node219
node63303:
.word 4407620
.word node27114
node87444:
.word 5461060
.word node18636
node219:
.word 4471108
.word node57184
node2784:
.word 4475716
.word node38248
node12159:
.word 4470596
.word node87444
node83724:
.word 4739396
.word 0
node73527:
.word 4733252
.word node43752
node865:
.word 4470852
.word node41348
node75158:
.word 5458756
.word node62512
node11428:
.word 4732740
.word node53378
node53378:
.word 4405060
.word node34938
node43542:
.word 4405572
.word node44670
node20928:
.word 4735300
.word node17703
node6803:
.word 4410180
.word node20928
node11484:
.word 5452356
.word node78329
node5753:
.word 4404292
.word node12159

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
jal simulate_game

# Write your own code here to verify that the function is correct.

li $v0, 10
syscall

.include "proj5.asm"
