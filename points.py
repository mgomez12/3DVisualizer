g = (1 + 5**.5)/2
l = []
h = 1/g
for i in [-1,1]:
	for j in [-1,1]:
		for k in [-1,1]:
			l.append((i,j,k))

for i in [-(1+h), 1+h]:
	for j in [-(1-h**2), 1-h**2]:
		for p in [(0, i, j), (i, j, 0), (j, 0, i)]:
			l.append(p)
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
        x[i] = x[i] + "0"*(12-len(x[i]))
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

