import random
import sys

n = int(sys.argv[1:][0])
s = ""
for _ in range(0, n):
    for __ in range(0, n):
        if __ in range(0, n - 1):
            s += str(round(random.uniform(10.2, 66.6), 2))
            s += ","
        else:
            s += str(round(random.uniform(10.2, 66.6), 2))
            s += "\n"

with open("inputx.txt", "w") as text_file:
    print(s, file=text_file)
