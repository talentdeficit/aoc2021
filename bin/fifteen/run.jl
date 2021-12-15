using DataStructures

input = joinpath(@__DIR__, "input")
lines = readlines(input)

m = hcat(map(line -> map(n -> parse(Int, n), collect(line)), lines)...)

function expand(m)
    acc = [m]
    for i in 1:4
        push!(acc, map(x -> mod1(x, 9), m.+ i))
    end
    tmp = hcat(acc...)
    acc = [tmp]
    for i in 1:4
        n = tmp.+ 1
        push!(acc, map(x -> mod1(x, 9), tmp.+ i))
    end
    return vcat(acc...)
end

function neighbors(m, idx)
    x, y = Tuple(idx)
    return filter(c -> checkbounds(Bool, m, c), [
        CartesianIndex(x + 1, y),
        CartesianIndex(x - 1, y),
        CartesianIndex(x, y + 1),
        CartesianIndex(x, y - 1)
    ])
end

function path(m, origin, dest)
    unvisited = Set{}(collect(CartesianIndices(m)))
    distances = Dict{CartesianIndex, Int}()
    candidates = PriorityQueue{CartesianIndex, Int}()
    node = CartesianIndex(1, 1)
    # initial node is free
    distances[node] = 0

    while dest in unvisited
        delete!(unvisited, node)
        cost = distances[node]
        for n in neighbors(m, node)
            haskey(distances, n) ? distances[n] = minimum([distances[n], cost + m[n]]) : distances[n] = cost + m[n]
            if n in unvisited
                haskey(candidates, n) ? candidates[n] = minimum([distances[n], cost + m[n]]) : candidates[n] = cost + m[n]
            end
        end
        node = dequeue!(candidates)
        node == dest && delete!(unvisited, dest)
    end
    return distances[dest]
end

p1 = path(m, CartesianIndex(1, 1), CartesianIndex(size(m)))
m = expand(m)
p2 = path(m, CartesianIndex(1, 1), CartesianIndex(size(m)))

println("-----------------------------------------------------------------------")
println("chiton -- part one :: $p1")
println("chiton -- part two :: $p2")
println("-----------------------------------------------------------------------")

@assert(p1 == 790)
@assert(p2 == 2998)
