input = read(joinpath(@__DIR__, "input"), String)
coords, instructions = split(input, "\n\n")

paper = Set()
for coord in split(coords, "\n")
    x, y = parse.(Int, match(r"(\d+),(\d+)", coord).captures)
    push!(paper, (x, y))
end

folds = []
for i in split(instructions, "\n", keepempty=false)
    dim, n = match(r".+([xy])=(\d+)$", i).captures
    push!(folds, (dim, parse(Int, n)))
end

function translatex(coord, n)
    x, y = coord
    x > n && return (n - (x - n), y)
    return (x, y)
end

function translatey(coord, n)
    x, y = coord
    y > n && return (x, n - (y - n))
    return (x, y)
end

function fold(paper, folds)
    paper = copy(paper)
    for (dim, n) in folds
        if dim == "x"
            paper = map(idx -> translatex(idx, n), collect(paper))
            paper = filter(idx -> first(idx) <= n, paper)
            paper = unique(paper)
        else
            paper = map(idx -> translatey(idx, n), collect(paper))
            paper = filter(idx -> last(idx) <= n, paper)
            paper = unique(paper)
        end
    end
    return paper
end

firstfold = first(folds)
p1 = length(fold(paper, [firstfold]))

paper = fold(paper, folds)
x = maximum(map(idx -> first(idx), collect(paper)))
y = maximum(map(idx -> last(idx), collect(paper)))

println("-----------------------------------------------------------------------")
println("transparent origami -- part one :: $p1")
println("transparent origami -- part two ::")
println()
for j in 0:y
    print("    ")
    for i in 0:x
        (i, j) in paper ? print("█") : print(" ")
    end
    println()
end
println()
println("-----------------------------------------------------------------------")

@assert(p1 == 759)
