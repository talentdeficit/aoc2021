using DelimitedFiles
using StatsBase

input = joinpath(@__DIR__, "input")
fish = readdlm(input, ',', Int)

function advance(fish, days)
    for _ in 1:days
        next = Dict()
        for (age, n) in fish
            if age == 0
                haskey(next, 6) ? next[6] += n : next[6] = n
                next[8] = n
            else
                haskey(next, age - 1) ? next[age - 1] += n : next[age - 1] = n
            end
        end
        fish = next
    end
    return fish
end

fish = countmap(vec(fish))

p1 = sum(map(fishes -> last(fishes), collect(advance(copy(fish), 80))))
p2 = sum(map(fishes -> last(fishes), collect(advance(copy(fish), 256))))

@assert(p1 == 383160)
@assert(p2 == 1721148811504)

println("-----------------------------------------------------------------------")
println("lanternfish -- part one :: $p1")
println("lanternfish -- part two :: $p2")
println("-----------------------------------------------------------------------")