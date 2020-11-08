from mpl_toolkits import mplot3d
import numpy as np
import matplotlib.pyplot as plt
import math



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

x_orig = []
y_orig = []
z_orig = []
pi=3.1415926
u_rate = .1
v_rate = .3
w_rate = .2
for p in l:
    x_orig.append(int( p[0] *2048/2))
    y_orig.append(int( p[1] *2048/2))
    z_orig.append(int( p[2] *2048/2))
x_orig = np.array(x_orig)
y_orig = np.array(y_orig)
z_orig = np.array(z_orig)
points = np.hstack((x_orig, y_orig, z_orig))
fig = plt.figure()
ax = plt.axes(projection='3d')

u = 0
v = 0
w = 0
x = [0]*20
y = [0]*20
z = [0]*20
plt.ion()
points = ax.scatter(x_orig, y_orig, z_orig)
plt.pause(1)
u = math.asin(0.0625)
print(2048*math.cos(u), 2048*math.sin(u))
v = math.asin(-0.0625)
w = math.asin(0.0625)
for i in range (0, 20):
    x[i] = (math.cos(u) * math.cos(v))*x_orig[i] + (math.cos(u) * math.sin(v)*math.sin(w) - math.sin(u)*math.cos(w))*y_orig[i] + (math.cos(u)*math.sin(v)*math.cos(w)+math.sin(u)*math.sin(w))*z_orig[i]
    y[i] = (math.sin(u) * math.cos(v))*x_orig[i] + (math.sin(u) * math.sin(v)*math.sin(w) + math.cos(u)*math.cos(w))*y_orig[i] + (math.sin(u)*math.sin(v)*math.cos(w)-math.cos(u)*math.sin(w))*z_orig[i]
    z[i] = -math.sin(v)*x_orig[i] + math.cos(v)*math.sin(w)*y_orig[i] + math.cos(v)*math.cos(w)*z_orig[i]
points = ax.scatter(x,y,z)
fig.canvas.draw_idle()
plt.pause(.01)

p = np.array([[-1],[-1],[-1]])
T = np.array([[1,0,0],[0,math.cos(u), -math.sin(u)], [0, math.sin(u), math.cos(u)]])
T2 = np.array([[math.cos(v), 0, math.sin(v)], [0, 1, 0], [-math.sin(v), 0, math.cos(v)]])
first = T@p
print(T@p)
print(T2@first)
print(x, y, z)


##while True:
##    for t in range(10):
##        for i in range (0, 20):
##            x[i] = (math.cos(u) * math.cos(v))*x_orig[i] + (math.cos(u) * math.sin(v)*math.sin(w) - math.sin(u)*math.cos(w))*y_orig[i] + (math.cos(u)*math.sin(v)*math.cos(w)+math.sin(u)*math.sin(w))*z_orig[i]
##            y[i] = (math.sin(u) * math.cos(v))*x_orig[i] + (math.sin(u) * math.sin(v)*math.sin(w) + math.cos(u)*math.cos(w))*y_orig[i] + (math.sin(u)*math.sin(v)*math.cos(w)-math.cos(u)*math.sin(w))*z_orig[i]
##            z[i] = -math.sin(v)*x_orig[i] + math.cos(v)*math.sin(w)*y_orig[i] + math.cos(v)*math.cos(w)*z_orig[i]
##        points.remove()
##        points = ax.scatter(x,y,z)
##        fig.canvas.draw_idle()
##        plt.pause(.01)
##        u += u_rate*pi*.02
##        v += v_rate*pi*.02
##        w += w_rate*pi*.02
##    u_rate = 2*np.random.random()-1
##    v_rate = 2*np.random.random()-1
##    w_rate = 2*np.random.random()-1
