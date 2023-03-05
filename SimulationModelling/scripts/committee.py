import random

# 0, 1, 2, 3 -- types of people
people = [0] * 6 + [1] * 6 + [2] * 10  + [3] * 11

success = 0
N = 100000
for _ in range(N):
    random.shuffle(people)
    committee = people[:6]

    all_in = True
    for i in range(4):
        all_in = all_in and (i in committee)

    if all_in:
        success += 1

print(success/N)
