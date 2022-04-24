import random
for _ in range(0, 128):
    for __ in range(0, 128):
        if __ in range(0, 127):
            print(round(random.uniform(10.2, 66.6), 2), end=",")
        else:
            print(round(random.uniform(10.23, 66.6), 2))