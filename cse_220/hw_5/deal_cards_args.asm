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