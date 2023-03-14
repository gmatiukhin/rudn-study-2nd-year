import random

N = 10000

avg = 0
for _ in range(N):
    count = 0
    prev_val = 0
    while True:
        val = random.random()
        if val < prev_val:
            break
        count += 1
        prev_val = val
    avg += count

print(avg / N)
