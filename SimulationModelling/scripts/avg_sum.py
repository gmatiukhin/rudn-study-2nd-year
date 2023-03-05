from numpy import random

samples = int(input("Samples: "))

sum = 0
for _ in range(samples):
    val = 0
    count = 0
    while val < 1:
        val += random.uniform(0, 1)
        count += 1
    sum += count
avg = sum / samples

print(avg)
