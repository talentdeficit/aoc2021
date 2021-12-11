input = joinpath(@__DIR__, "input")
lines = readlines(input)

m = hcat(map(line -> map(n -> parse(Int, n), collect(line)), lines)...)

function neighbors(m, idx)
    x, y = Tuple(idx)
    return filter(c -> checkbounds(Bool, m, c), [
        CartesianIndex(x + 1, y),
        CartesianIndex(x - 1, y),
        CartesianIndex(x, y + 1),
        CartesianIndex(x, y - 1)
    ])
end

function lowpoint(m, idx)
    ns = neighbors(m, idx)
    return all(i -> m[i] > m[idx], ns) ? idx : nothing
end

function basins(m, idx)
    basin = Set()
    prospects = [idx]
    while length(prospects) > 0
        curr = pop!(prospects)
        ch = m[curr]
        ns = neighbors(m, curr)
        for n in ns
            if m[n] > ch && m[n] < 9 && !(n in basin)
                push!(prospects, n)
            end
        end
        push!(basin, curr)
    end
    return length(basin)
end

lowpoints = filter(!isnothing, map(idx -> lowpoint(m, idx), CartesianIndices(m)))
p1 = sum([m[n] + 1 for n in lowpoints])
p2 = prod(sort(map(idx -> basins(m, idx), lowpoints), lt=!isless)[1:3])

println("-----------------------------------------------------------------------")
println("smoke basin -- part one :: $p1")
println("smoke basin -- part two :: $p2")
println("-----------------------------------------------------------------------")

@assert(p1 == 524)
@assert(p2 == 1235430)
