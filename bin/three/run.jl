using DelimitedFiles

input = joinpath(@__DIR__, "input")
raw = readdlm(input, String)

function decimalize(vec)
    reverse!(vec)
    return sum(2^i * x for (i, x) in zip(0:length(vec) - 1, vec))
end

function rating(diagnostics, mcf)
    for i in 1:length(first(diagnostics))
        mc = mcf(diagnostics)
        filter!(d -> d[i] == mc[i], diagnostics)
        if length(diagnostics) == 1
            return first(diagnostics)
        end
    end
end

diagnostics = vec([Vector{Char}(entry) .- '0' for entry in raw])

sums = sum(diagnostics)

mc = sums .> (length(diagnostics) / 2)
lc = sums .< (length(diagnostics) / 2)

gamma = decimalize(mc)
epsilon = decimalize(lc)

oxygen = decimalize(rating(copy(diagnostics), ds -> sum(ds) .>= length(ds) / 2))
scrubber = decimalize(rating(copy(diagnostics), ds -> sum(ds) .< length(ds) / 2))

p1 = gamma * epsilon
p2 = oxygen * scrubber

@assert(p1 == 738234)
@assert(p2 == 3969126)

println("-----------------------------------------------------------------------")
println("binary diagnostic -- part one :: $p1")
println("binary diagnostic -- part two :: $p2")
println("-----------------------------------------------------------------------")