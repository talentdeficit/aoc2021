input = joinpath(@__DIR__, "input")
lines = readlines(input)

m = Array{Int, 2}(undef, length(lines), length(lines[1]))

for y in 1:length(lines)
    for x in 1:length(lines[1])
        m[y, x] = lines[y][x] - '0'
    end
end

function neighbors(m, idx)
    (x, y) = Tuple(idx)
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
            if m[n] > ch && m[n] < 9
                push!(prospects, n)
            end
        end
        push!(basin, curr)
    end
    return length(basin)
end

lowpoints = filter(!isnothing, map(idx -> lowpoint(m, idx), CartesianIndices(m)))
p1 = sum([m[n] + 1 for n in lowpoints])
p2 = prod(sort(map(idx -> basins(m, idx), lowpoints))[end-2:end])

@assert(p1 == 524)
@assert(p2 == 1235430)

println("-----------------------------------------------------------------------")
println("smoke basin -- part one :: $p1")
println("smoke basin -- part two :: $p2")
println("-----------------------------------------------------------------------")
