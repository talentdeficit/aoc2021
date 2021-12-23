using DataStructures

input = joinpath(@__DIR__, "input")
lines = readlines(input)

M = hcat(map(line -> collect(line), lines)...)

# p2 adjustment
newlines = []
append!(newlines, lines[1:3])
append!(newlines, ["  #D#C#B#A#  "])
append!(newlines, ["  #D#B#A#C#  "])
append!(newlines, lines[4:end])
N = hcat(map(line -> collect(line), newlines)...)

function p(m)
    y, x = size(m)
    for i in 1:x
        for j in 1:y
            print(m[CartesianIndex(j, i)])
        end
        println()
    end
end

function path(amphipod, space)
    x, y = Tuple(amphipod)
    dx, dy = Tuple(space)
    # x translation is the same for both cases
    path = [CartesianIndex(i, 2) for i in min(x, dx):max(x, dx)]
    # amphipod moving to hallway
    if dy != 2
        append!(path, [CartesianIndex(dx, i) for i in min(y, dy):max(y, dy)])
    # amphipod moving home
    else
        append!(path, [CartesianIndex(x, i) for i in min(y, dy):max(y, dy)])
    end
    unique!(path)
    filter!(idx -> idx != amphipod, path)
    return path
end

function cost(amphipod, p, m)
    a = m[amphipod]
    multiplier = 1
    if a == 'A'
        multiplier = 1
    elseif a == 'B'
        multiplier = 10
    elseif a == 'C'
        multiplier = 100
    elseif a == 'D'
        multiplier = 1000
    end
    return length(p) * multiplier
end

function desirable(amphipod, destination, m)
    a = m[amphipod]
    home = HOMES[a]
    y, x = Tuple(amphipod)
    dy, dx = Tuple(destination)

    # already "home". won't move
    amphipod in home && all(idx -> m[idx] == a, filter(idx -> idx > amphipod, home)) && return false

    # in hallway, will only move if destination is "home" and is empty and either the last space in room
    # or next to a similar amphipod
    if x == 2
        # destination not in hallway
        dx == 2 && return false
        # destination not in home row
        !(destination in home) && return false
        # destination is occupied
        m[destination] != '.' && return false
        # destination is deepest unoccupied spot
        destination != maximum(filter(idx -> m[idx] == '.', home)) && return false
        # room has non similar amphipods
        any(idx -> m[idx] != a, filter(idx -> idx > destination, home)) && return false
        return true
    # in side room, can always try to move to hallway
    elseif dx == 2
        return true
    # trying to move from hallway to hallway or room to room
    else
        return false
    end
end

function moves(m)
    # all legal spaces
    legal = LEGAL
    # all spaces currently occupied
    amphipods = filter(idx -> m[idx] in ['A', 'B', 'C', 'D'], CartesianIndices(m))
    # unoccupied spaces
    unoccupied = setdiff(legal, amphipods)

    acc = []
    for amphipod in amphipods
        # remove any side rooms that the amphipod doesn't like
        available = filter(idx -> desirable(amphipod, idx, m), unoccupied)
        for space in available
            pa = path(amphipod, space)
            if all(idx -> m[idx] == '.', pa)
                c = cost(amphipod, pa, m)
                n = copy(m)
                n[amphipod] = '.'
                n[space] = m[amphipod]
                push!(acc, (n, c))
            end
        end
    end
    return acc
end

# terrible heuristic. couldn't find a good heuristic for p2
function estimate(m, goal)
    return 0
end

function astar(start, goal, heuristic)
    open = PriorityQueue()
    open[start] = heuristic(start, goal)

    g = DefaultDict(typemax(Int))
    g[start] = 0

    # solution path, because i have no idea what i'm doing
    cf = Dict()

    rounds = 0

    while !isempty(open)
        current = dequeue!(open)
        # fin
        current == goal && return (g[current], cf)

        for move in moves(current)
            next, cost = move
            tentative = g[current] + cost
            if tentative < g[next]
                cf[next] = current
                g[next] = tentative
                open[next] = tentative + heuristic(next, goal)
            end
        end
    end

    return (nothing, nothing)
end

function solution(cf, goal)
    current = goal
    while current in keys(cf)
        current = cf[current]
        p(current)
        println()
    end
end

LEGAL = [
    CartesianIndex(2,2),
    CartesianIndex(3,2),
    CartesianIndex(5,2),
    CartesianIndex(7,2),
    CartesianIndex(9,2),
    CartesianIndex(11,2),
    CartesianIndex(12,2),
    CartesianIndex(4,3),
    CartesianIndex(4,4),
    CartesianIndex(6,3),
    CartesianIndex(6,4),
    CartesianIndex(8,3),
    CartesianIndex(8,4),
    CartesianIndex(10,3),
    CartesianIndex(10,4)
]

A = [CartesianIndex(4,3), CartesianIndex(4,4)]
B = [CartesianIndex(6,3), CartesianIndex(6,4)]
C = [CartesianIndex(8,3), CartesianIndex(8,4)]
D = [CartesianIndex(10,3), CartesianIndex(10,4)]
HOMES = Dict([('A', A), ('B', B), ('C', C), ('D', D)])

# construct goal
goal = copy(M)
goal[CartesianIndex(4,3)] = 'A'
goal[CartesianIndex(4,4)] = 'A'
goal[CartesianIndex(6,3)] = 'B'
goal[CartesianIndex(6,4)] = 'B'
goal[CartesianIndex(8,3)] = 'C'
goal[CartesianIndex(8,4)] = 'C'
goal[CartesianIndex(10,3)] = 'D'
goal[CartesianIndex(10,4)] = 'D'


p1, cf = astar(copy(M), goal, estimate)
# solution(cf, goal)

append!(LEGAL, [
    CartesianIndex(4,5),
    CartesianIndex(4,6),
    CartesianIndex(6,5),
    CartesianIndex(6,6),
    CartesianIndex(8,5),
    CartesianIndex(8,6),
    CartesianIndex(10,5),
    CartesianIndex(10,6)
])

append!(A, [CartesianIndex(4,5), CartesianIndex(4,6)])
append!(B, [CartesianIndex(6,5), CartesianIndex(6,6)])
append!(C, [CartesianIndex(8,5), CartesianIndex(8,6)])
append!(D, [CartesianIndex(10,5), CartesianIndex(10,6)])
HOMES = Dict([('A', A), ('B', B), ('C', C), ('D', D)])

# construct goal
goal = copy(N)
goal[CartesianIndex(4,3)] = 'A'
goal[CartesianIndex(4,4)] = 'A'
goal[CartesianIndex(6,3)] = 'B'
goal[CartesianIndex(6,4)] = 'B'
goal[CartesianIndex(8,3)] = 'C'
goal[CartesianIndex(8,4)] = 'C'
goal[CartesianIndex(10,3)] = 'D'
goal[CartesianIndex(10,4)] = 'D'
goal[CartesianIndex(4,5)] = 'A'
goal[CartesianIndex(4,6)] = 'A'
goal[CartesianIndex(6,5)] = 'B'
goal[CartesianIndex(6,6)] = 'B'
goal[CartesianIndex(8,5)] = 'C'
goal[CartesianIndex(8,6)] = 'C'
goal[CartesianIndex(10,5)] = 'D'
goal[CartesianIndex(10,6)] = 'D'

p2, cf = astar(copy(N), goal, estimate)
# solution(cf, goal)

println("-----------------------------------------------------------------------")
println("amphipod -- part one :: $p1")
println("amphipod -- part two :: $p2")
println("-----------------------------------------------------------------------")

@assert(p1 == 10607)
@assert(p2 == 59071)
