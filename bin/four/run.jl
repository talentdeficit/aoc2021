input = joinpath(@__DIR__, "input")
lines = readlines(input)

numbers = map(n -> parse(Int, n), split(lines[1], ','))
boards = lines[2:end]

function genboards(boards)
    filter!(l -> l != "", boards)
    rows = map(l -> map(r -> parse(Int, r), split(l)), boards)
    acc = []
    while length(rows) != 0
        append!(acc, [rows[1:5]])
        rows = rows[6:end]
    end
    return acc
end

function score(numbers, board)
    for i in 1:length(numbers)
        drawn = numbers[1:i]
        b = copy(board)
        # rows (b) and columns (map(collect, zip(b...)))
        append!(b, map(collect, zip(b...)))
        for s in b
            if issubset(s, drawn)
                rem = setdiff(Iterators.flatten(board), drawn)
                # return score and "round" board won in
                return (length(drawn), sum(rem) * last(drawn))
            end
        end
    end
end

boards = genboards(boards)
scores = map(b -> score(numbers, b), boards)

(_, fastest) = minimum(scores)
(_, slowest) = maximum(scores)

p1 = fastest
p2 = slowest

@assert(p1 == 44736)
@assert(p2 == 1827)

println("-----------------------------------------------------------------------")
println("giant squid -- part one :: $p1")
println("giant squid -- part two :: $p2")
println("-----------------------------------------------------------------------")
