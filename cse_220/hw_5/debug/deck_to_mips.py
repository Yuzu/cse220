import binascii

# Enter string here
deck = '''DTC D6D D3H D3D D7H DAS D5D D2S DQS D4S DKC D9C D2D D7S D6S DJC D5H D6H D4H D2C DQC D8S D3S DAC D3C D7C DTD DKH D5S D8C D7D DTS D2H D8D D6C D5C D4D D9S DQD D8H DJD DQH D9H DKD DAD DAH DKS DTH D9D D4C DJS DJH'''

# enter # of rounds here
num_rounds = 8

out ='''

num_rounds: .word {0}\n
.align 2

deck:
.word 52
.word node0
'''.format(str(num_rounds))

nodenum = 0
for x in deck.split(" "):
    
    x = x.encode(encoding="ascii")
    x = int.from_bytes(x, byteorder="little")

    out += "node{0}:\n".format(str(nodenum))
    out += ".word {0}\n".format(str(x))
    nodenum += 1
    
    if nodenum == 52:
        out += ".word 0"
        break
    out += ".word node{0}\n".format(str(nodenum))
    

out.strip()

print(out)
