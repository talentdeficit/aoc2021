input = joinpath(@__DIR__, "input")
lines = readlines(input)

function p(lines)
    points = Set()
    folds = []
    i = 1
    while true
        lines[i] == "" && break
        parts = map(n -> parse(Int, n), split(lines[i], ","))
        push!(points, (first(parts), last(parts)))
        i += 1
    end
    i += 1
    while true
        i > length(lines) && break
        parts = split(last(split(lines[i], " ")), "=")
        push!(folds, (first(collect(first(parts))), parse(Int, last(parts)) + 1))
        i += 1
    end
    x = maximum(map(coord -> first(coord), collect(points)))
    y = maximum(map(coord -> last(coord), collect(points)))
    # input needs an extra row
    paper = zeros(x + 1, y + 2)
    for point in collect(points)
        (x, y) = point
        paper[CartesianIndex(x + 1, y + 1)] = 1
    end
    return (paper, folds)
end

(paper, folds) = p(lines)

function foldonce(paper, dim, idx)
    if dim == 'x'
        left = paper[1:idx - 1, :]
        right = paper[(idx + 1):end, :]
        reverse!(left, dims=1)
        return reverse!(left .+ right, dims=1)
    elseif dim == 'y'
        left = paper[:, 1:idx - 1]
        right = paper[:, (idx + 1):end]
        reverse!(left, dims=2)
        return reverse!(left .+ right, dims=2)
    end
end

function fold(paper, folds)
    paper = copy(paper)
    for fold in folds
        paper = foldonce(paper, first(fold), last(fold))
    end
    return paper
end

(dim, idx) = first(folds)
m = foldonce(paper, dim, idx)
p1 = length(findall(n -> n > 0, m))

paper = fold(paper, folds)
coords = findall(n -> n > 0, paper)
(x, y) = size(paper)


println("-----------------------------------------------------------------------")
println("transparent origami -- part one :: $p1")
println("transparent origami -- part two ::")
println()
for i in 1:y
    print("    ")
    for j in 1:x
        paper[CartesianIndex(j, i)] > 0 ? print("█") : print(" ")
    end
    println()
end
println()
println("-----------------------------------------------------------------------")

@assert(p1 == 759)