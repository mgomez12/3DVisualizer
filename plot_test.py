from mpl_toolkits import mplot3d
import numpy as np
import matplotlib.pyplot as plt
import math

res = [( -1228,  -1638,  -4896),
(  -877,  -1170,  -1152),
( -1228,   1638,  -4896),
(  -877,   1170,  -1152),
(  1228,  -1638,  -4896),
(   877,  -1170,  -1152),
(  1228,   1638,  -4896),
(   877,   1170,  -1152),
(     0,  -2461,  -3968),
( -1656,   -842,  -2720),
(  -865,      0,  -6752),
(     0,  -2002,  -1696),
( -1656,    842,  -2720),
(   865,      0,  -6752),
(     0,   2461,  -3968),
(  1656,   -842,  -2720),
(  -497,      0,   -384),
(     0,   2002,  -1696),
(  1656,    842,  -2720),
(   497,      0,   -384)]

r_x = [p[0] for p in res]
r_y = [p[1] for p in res]
r_z = [p[2] for p in res]

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
ax = plt.axes()

u = 0
v = 0
w = 0
x = [0]*20
y = [0]*20
z = [0]*20
plt.ion()
#points = ax.scatter(x_orig, y_orig, z_orig)
ax.scatter(r_x, r_y)
ax.set_aspect(3/4)
ax.set_xlim(-8192, 8192)
ax.set_ylim(-8192, 8192)
#ax.set_zlim(-8192, 8192)
fig.canvas.draw_idle()
plt.pause(1)
##ax.set_xlim(-8192, 8192)
##ax.set_ylim(-8192, 8192)
##ax.set_zlim(-8192, 8192)
##plt.pause(1)
##u = math.asin(0.0625)
##print(2048*math.cos(u), 2048*math.sin(u))
##v = math.asin(-0.0625)
##w = math.asin(0.0625)
##for i in range (0, 20):
##    x[i] = (math.cos(u) * math.cos(v))*x_orig[i] + (math.cos(u) * math.sin(v)*math.sin(w) - math.sin(u)*math.cos(w))*y_orig[i] + (math.cos(u)*math.sin(v)*math.cos(w)+math.sin(u)*math.sin(w))*z_orig[i]
##    y[i] = (math.sin(u) * math.cos(v))*x_orig[i] + (math.sin(u) * math.sin(v)*math.sin(w) + math.cos(u)*math.cos(w))*y_orig[i] + (math.sin(u)*math.sin(v)*math.cos(w)-math.cos(u)*math.sin(w))*z_orig[i]
##    z[i] = -math.sin(v)*x_orig[i] + math.cos(v)*math.sin(w)*y_orig[i] + math.cos(v)*math.cos(w)*z_orig[i]
####points = ax.scatter(x,y,z)
####fig.canvas.draw_idle()
##plt.pause(1)
##
##points = ax.scatter(r_x, r_y, rz)


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
