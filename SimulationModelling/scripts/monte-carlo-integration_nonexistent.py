from numpy import random, sqrt, sin, pi

def func(x):
    n = 3
    return (x**n)/(sin(x)**(n+1))

a = 0
b = pi / 2

N = int(input("Samples: "))

it_res = 0
for i in range(N):
    x = random.uniform(a, b)
    it_res += func(x)

res = (b - a) * (1 / N) * it_res
print(res)
