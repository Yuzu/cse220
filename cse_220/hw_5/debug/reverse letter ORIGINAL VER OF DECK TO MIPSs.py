import binascii

# Enter string here
deck = '''D8C D4H D7H D7C D2D DJD DAD DQD DTC D8S D9C D3D DKC DAH D2H DJH D9H D2C D5H D8H D7S D9D D5D D2S DJS D4S DKH D8D D6C D5S D9S DQS D4C D7D DTS DTH D5C DKD D6H D3S DKS D3H D6D DJC DQC D6S D4D DTD DAC D3C DAS DQH'''

# enter # of rounds here
num_rounds = 5

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
