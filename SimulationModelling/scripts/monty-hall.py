import random


N = 100000
switch = 0
not_switch = 0

for _ in range(N):
    prize = random.randint(0, 2)
    choice = random.randint(0, 2)

    # open one door
    doors = set(range(3))
    doors.discard(prize)
    doors.discard(choice)
    open = doors.pop()

    # switch 
    switch += prize != choice
    not_switch += prize == choice

print(f"switch: {switch/N}")
print(f"not switch: {not_switch/N}")
