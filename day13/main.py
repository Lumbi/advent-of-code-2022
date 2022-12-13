from functools import cmp_to_key

def compare(a, b):
    if isinstance(a, int) and isinstance(b, int):
        if a < b: return 1
        if b < a: return -1
        return 0

    if isinstance(a, int):
        return compare([a], b)

    if isinstance(b, int):
        return compare(a, [b])

    if not a and not b: return 0

    for i in range(max(len(a), len(b))):
        if i >= len(a): return 1
        if i >= len(b): return -1
        result = compare(a[i], b[i])
        if result == 1 or result == -1: return result

    return 0

def star1():
    with open('input.txt', 'r+') as file:
        index = 0
        sum = 0
        while True:
            index += 1
            line = file.readline()
            left = eval(line)
            line = file.readline()
            right = eval(line)
            line = file.readline()

            if compare(left, right) == 1:
                sum += index

            if not line: break

        print("star1:", sum)


def star2():
    with open('input.txt', 'r+') as file:
        packets = []
        while True:
            line = file.readline()
            if len(line.strip()) > 0 : packets.append(eval(line))
            if not line: break

        packets.append([[2]])
        packets.append([[6]])

        packets.sort(key=cmp_to_key(compare))
        packets.reverse()

        decoder_key = 1
        index = 0

        for packet in packets:
            index += 1
            if packet == [[2]]:
                decoder_key *= index
            if packet == [[6]]:
                decoder_key *= index

        print("star2:", decoder_key)

star1()

star2()
