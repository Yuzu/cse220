def getFrequencies(arg1):
    frequencies = {}

    for x in range(len(arg1)-1):
        bytepair = arg1[x] + arg1[x+1]

        if arg1[x].isupper() or arg1[x+1].isupper():
            continue
        frequencies.setdefault(bytepair, 0)

        frequencies[bytepair] += 1

    return frequencies

def main():
    string = "aabbacbacbacbacbababababcabbacabca"

    result1 = getFrequencies(string)

    print(result1)

    string2 = "aabZcZcZcZcZZZZbcabZcabca"

    result2 = getFrequencies(string2)

    print(result2)

main()
