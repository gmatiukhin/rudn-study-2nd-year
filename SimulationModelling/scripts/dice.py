import random

N = 100000

counts = 0
for _ in range(N):
    possible_sums = [x for x in range(2, 12 + 1)]
    count = 0
    while possible_sums:
        die1 = random.randint(1,6)
        die2 = random.randint(1,6)
        sum = die1 + die2
        
        if sum in possible_sums:
            possible_sums.remove(sum)

        count += 1
    counts += count

print(counts/N)
