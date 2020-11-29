import random
import math
l = []
for n in range(300):
        z = random.random()*4-2
        rho = random.random()*2*3.14159265
        l.append((math.sqrt(4-z**2)*math.cos(rho), math.sqrt(4-z**2)*math.sin(rho), z))
print(l)

a = []
for p in l:
    n = []
    for c in p:
        n.append(int( c *2048/2))
    a.append(tuple(n))
print(a)

s = []
for p in a:
    x = [bin(p[0] & 0xfff)[2:], bin(p[1] & 0xfff)[2:], bin(p[2] & 0xfff)[2:]]
    for i in range(3):
        x[i] = "0"*(12-len(x[i])) + x[i]
    s.append(''.join(x))
print(s)
with open("points.coe", "w") as g:
    g.write("memory_initialization_radix=2;\n")
    g.write("memory_initialization_vector=\n")
    for p in range(len(s)):
        g.write(s[p])
        if p == len(s)-1:
            g.write(";\n")
        else:
            g.write(",\n")

