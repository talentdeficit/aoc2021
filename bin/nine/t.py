f = open('input', 'r')
data = f.read().split('\n')
f.close()

lines = [[ int(c) for c in line ] for line in data]

def get_neigh(x,y):
    neigh = []
    if x+1 < len(lines[0]):
        neigh.append(lines[y][x+1])
    if x-1 >= 0:
        neigh.append(lines[y][x-1])
    if y+1 < len(lines):
        neigh.append(lines[y+1][x])
    if y-1 >= 0:
        neigh.append(lines[y-1][x])
    return neigh

result = 0
for y in range(0, len(lines)):
    for x in range(0, len(lines[0])):
        if lines[y][x] < min(get_neigh(x,y)):
            result += 1 + lines[y][x]

print(result)
