xi = {
    -1: 0.47,
    2: 0.53
}
eta = {
    -1: 0.37,
    0: 0.29,
    1: 0.34
}

xi_exp = 0
for k, v in xi.items():
    xi_exp += k * v

eta_exp = 0
for k, v in eta.items():
    eta_exp += k * v

print(xi_exp)
print(eta_exp)

disp = 0

#bad
i = 0
ps = [0.12, 0.14, 0.21, 0.25, 0.15, 0.13]

for kx in xi:
    for ke in eta:
        disp += (kx - xi_exp) * (ke - eta_exp) * ps[i]
        i += 1

print(disp)
