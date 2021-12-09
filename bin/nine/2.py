import math

f = open('input', 'r')
data = f.read().split('\n')
f.close()

lines = [[ int(c) for c in line ] for line in data]

basins = []

def count_basins(x,y, initial=False):
    if y < 0 or y >= len(lines) or x < 0 or x >= len(lines[0]) or lines[y][x] == 9 or lines[y][x] == -1:
        return
    if initial:
        basins.append(0)
    else:
        basins[len(basins)-1] += 1
        lines[y][x] = -1
    count_basins(x+1,y)
    count_basins(x-1,y)
    count_basins(x,y+1)
    count_basins(x,y-1)

for i in range(0, len(lines)):
    for j in range(0, len(lines[0])):
        count_basins(j,i, True)

basins.sort()
basins.reverse()
print(math.prod(basins[:3]))
