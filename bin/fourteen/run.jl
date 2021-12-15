using StatsBase

input = joinpath(@__DIR__, "input")
lines = readlines(input)

template = lines[1]
rules = lines[3:end]

rules = map(line -> split(line, " -> "), rules)

function replacements(rules)
    rs = Dict{String, Tuple{String, String}}()

    for (pair, insert) in rules
        l = first(pair) * insert
        r = insert * last(pair)
        rs[pair] = (l, r)
    end

    return rs
end

function expand(template, rules, n)
    counts = Dict{String, Int}()
    for i in 1:(length(template) - 1)
        pair = template[i:i+1]
        haskey(counts, pair) ? counts[pair] += 1 : counts[pair] = 1
    end

    for _ in 1:n
        ncounts = Dict{String, Int}()
        for (pair, ns) in collect(counts)
            l, r = rules[pair]
            haskey(ncounts, l) ? ncounts[l] += ns : ncounts[l] = ns
            haskey(ncounts, r) ? ncounts[r] += ns : ncounts[r] = ns
        end
        counts = ncounts
    end

    return counts
end

function solve(counts)
    cm = Dict{Char, Int}()
    for pair in keys(counts)
        ch = first(pair)
        haskey(cm, ch) ? cm[ch] += counts[pair] : cm[ch] = counts[pair]
    end

    cm[last(template)] += 1

    mini, maxi = extrema(values(cm))
    return maxi - mini
end

rules = replacements(rules)
counts = expand(template, rules, 10)
p1 = solve(counts)
counts = expand(template, rules, 40)
p2 = solve(counts)

println("-----------------------------------------------------------------------")
println("extended polymerization -- part one :: $p1")
println("extended polymerization -- part two :: $p2")
println("-----------------------------------------------------------------------")

@assert(p1 == 2027)
@assert(p2 == 2265039461737)

