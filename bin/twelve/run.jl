input = joinpath(@__DIR__, "input")
lines = readlines(input)

pairs = map(line -> split(line, "-"), lines)
pairs = map(pair -> (first(pair), last(pair)), pairs)

function neighbors(node, pairs)
    ns = Set()
    for p in pairs
        if first(p) == node && last(p) != "start"
            push!(ns, last(p))
        elseif last(p) == node && first(p) != "start"
            push!(ns, first(p))
        end
    end
    return ns
end

function small(node)
    chars = collect(node)
    return all(char -> char in collect("abcdefghijklmnopqrstuvwxyz"), chars)
end

function paths(current, pairs, visited, visitedtwice)
    v = copy(visited)
    current == "end" && return 1
    if small(current) && current in v
        if visitedtwice == nothing
            visitedtwice = current
        else
            return 0
        end
    end
    push!(v, current)
    count = 0
    ns = neighbors(current, pairs)
    for n in ns
        count += paths(n, pairs, v, visitedtwice)
    end
    return count
end

p1 = paths("start", pairs, Set(), false)
p2 = paths("start", pairs, Set(), nothing)

println("-----------------------------------------------------------------------")
println("passage pathing -- part one :: $p1")
println("passage pathing -- part two :: $p2")
println("-----------------------------------------------------------------------")

@assert(p1 == 4186)
@assert(p2 == 92111)
