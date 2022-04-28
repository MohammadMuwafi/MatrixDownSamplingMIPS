import random
import sys

n = int(sys.argv[1:][0])
m = int(sys.argv[1:][1])

s = ""
for _ in range(0, n):
    for __ in range(0, m):
        if __ in range(0, m - 1):
            s += str(round(random.uniform(10.2, 66.6), 2))
            s += ","
        else:
            s += str(round(random.uniform(10.2, 66.6), 2))
            s += "\n"


s = s[:-1]
with open("input.txt", "w") as text_file:
    print(s, file=text_file)

# ss = s.replace(",", " ")
# with open("inputz.txt", "w") as text_file:
#     print(ss, file=text_file)
