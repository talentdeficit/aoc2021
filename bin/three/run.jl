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

diagnostics = map(vec(raw)) do diagnostic
    map(n -> parse(Int, n), collect(diagnostic))
end

sums = sum(diagnostics)

gamma = decimalize(sums .>= (length(diagnostics) / 2))
epsilon = decimalize(sums .< (length(diagnostics) / 2))

oxygen = decimalize(rating(copy(diagnostics), ds -> sum(ds) .>= length(ds) / 2))
scrubber = decimalize(rating(copy(diagnostics), ds -> sum(ds) .< length(ds) / 2))

p1 = gamma * epsilon
p2 = oxygen * scrubber

println("-----------------------------------------------------------------------")
println("binary diagnostic -- part one :: $p1")
println("binary diagnostic -- part two :: $p2")
println("-----------------------------------------------------------------------")

@assert(p1 == 738234)
@assert(p2 == 3969126)
