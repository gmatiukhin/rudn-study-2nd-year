import random
import math

ratio = 0.0063
R = 10
vol = 4 / 3 * math.pi * R**3
n = vol * ratio


def point_dist(r):
    d = 0
    x = 0
    y = 0
    z = 0
    while math.sqrt(d) > r:
        x = random.uniform(-r, r)
        y = random.uniform(-r, r)
        z = random.uniform(-r, r)
        d = x * x + y * y + z * z
    return math.sqrt(d)


N = 10000
avg = 0
for _ in range(N):
    count = 0
    for _ in range(int(n)):
        p_d = point_dist(R)
        if p_d < 1:
            avg += 1

print(avg / N)
