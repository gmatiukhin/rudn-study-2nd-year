import random

N = 10000

avg_val = 0
avg_dev = 0
for _ in range(1, N):
    n = 100
    data = [random.choice([-1, 1]) for _ in range(n)]
    avg_val += sum(data) / n
    mean = sum(data) / n
    deviations = [(x - mean) ** 2 for x in data]
    avg_dev = sum(deviations) / n

print(avg_val / N, avg_dev / N)
