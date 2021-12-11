using StatsBase

input = joinpath(@__DIR__, "input")
lines = readlines(input)

function endpoints(line)
    components = map(n -> parse(Int, n), split(line, r",| -> "))
    return ((components[1], components[2]), (components[3], components[4]))
end    

function orthogonals(coords)
    map(c -> begin
        (start, finish) = c
        if start[1] == finish[1]
            [(start[1], i) for i in minimum([start[2], finish[2]]):maximum([start[2], finish[2]])]
        elseif start[2] == finish[2]
            [(i, start[2]) for i in minimum([start[1], finish[1]]):maximum([start[1], finish[1]])]
        else
            nothing
        end
    end, coords)
end

function diagonals(coords)
    map(c -> begin
        (start, finish) = c
        if start[1] < finish[1] && start[2] < finish[2]
            return collect(zip(start[1]:finish[1], start[2]:finish[2]))
        elseif start[1] > finish[1] && start[2] > finish[2]
            return collect(zip(start[1]:-1:finish[1], start[2]:-1:finish[2]))
        elseif start[1] < finish[1] && start[2] > finish[2]
            return collect(zip(start[1]:finish[1], start[2]:-1:finish[2]))
        elseif start[1] > finish[1] && start[2] < finish[2]
            return collect(zip(start[1]:-1:finish[1], start[2]:finish[2]))
        else
            nothing
        end
    end, coords)
end

coords = map(endpoints, lines)
orthos = filter(!isnothing, orthogonals(coords))
dias = filter(!isnothing, diagonals(coords))

p1 = length(filter(p -> last(p) > 1, countmap(Iterators.flatten(orthos))))
p2 = length(filter(p -> last(p) > 1, countmap(Iterators.flatten(append!(orthos, dias)))))

println("-----------------------------------------------------------------------")
println("hydrothermal venture -- part one :: $p1")
println("hydrothermal venture -- part two :: $p2")
println("-----------------------------------------------------------------------")

@assert(p1 == 6005)
@assert(p2 == 23864)
