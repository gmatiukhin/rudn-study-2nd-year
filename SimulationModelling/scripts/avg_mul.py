from numpy import random, e

samples = int(input("Samples: "))

sum = 0
for _ in range(samples):
    val = 1
    count = 0
    while val > e**(-3):
        val *= random.uniform(0, 1)
        count += 1
    sum += count
avg = sum / samples

print(avg)
