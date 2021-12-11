input = joinpath(@__DIR__, "input")
lines = readlines(input)

m = hcat(map(line -> map(n -> parse(Int, n), collect(line)), lines)...)

function neighbors(m, idx)
    x, y = Tuple(idx)
    return filter(c -> checkbounds(Bool, m, c), [
        CartesianIndex(x + 1, y),
        CartesianIndex(x - 1, y),
        CartesianIndex(x, y + 1),
        CartesianIndex(x, y - 1),
        CartesianIndex(x + 1, y + 1),
        CartesianIndex(x - 1, y - 1),
        CartesianIndex(x - 1, y + 1),
        CartesianIndex(x + 1, y - 1)
    ])
end

function step(m, limit)
    counter = 0
    for i in 1:limit
        m = m .+ 1
        octopii = Set()
        flashed = Set()
        for idx in CartesianIndices(m)
            push!(octopii, idx)
            while !isempty(octopii)
                o = pop!(octopii)
                if m[o] > 9 && !(o in flashed)
                    push!(flashed, o)
                    ns = neighbors(m, o)
                    for n in ns
                        m[n] = m[n] + 1
                        push!(octopii, n)
                    end
                end
            end
        end
        for f in flashed
            m[f] = 0
        end
        if length(flashed) == 100
            return (i, counter)
        end
        counter += length(flashed)
    end
    return (limit, counter)
end

(_, p1) = step(m, 100)
(p2, _) = step(m, 1000)

println("-----------------------------------------------------------------------")
println("dumbo octopus -- part one :: $p1")
println("dumbo octopus -- part two :: $p2")
println("-----------------------------------------------------------------------")

@assert(p1 == 1632)
@assert(p2 == 303)
