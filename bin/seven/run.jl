using DelimitedFiles

input = joinpath(@__DIR__, "input")
crabs = readdlm(input, ',', Int)

function align_crabs(crabs, fuel_calc)
    acc = []
    for i in 1:maximum(crabs)
        append!(acc, sum(map(n -> fuel_calc(i, n), crabs)))
    end
    return acc
end

p1 = minimum(align_crabs(crabs, (i, n) -> abs(i - n)))
p2 = minimum(align_crabs(crabs, (i, n) -> sum(1:abs(i - n))))

@assert(p1 == 343468)
@assert(p2 == 96086265)

println("-----------------------------------------------------------------------")
println("the treachery of whales -- part one :: $p1")
println("the treachery of whales -- part two :: $p2")
println("-----------------------------------------------------------------------")