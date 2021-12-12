input = joinpath(@__DIR__, "input")
lines = readlines(input)

function inputs(lines)
    map(line -> split(first(split(line, " | ")), " "), lines)
end

function outputs(lines)
    map(line -> split(last(split(line, " | ")), " "), lines)
end

# listed in order they are tried
parser = Dict{}()
parser[1] = (pattern, _) -> length(pattern) == 2
parser[4] = (pattern, _) -> length(pattern) == 4
parser[7] = (pattern, _) -> length(pattern) == 3
parser[8] = (pattern, _) -> length(pattern) == 7
parser[9] = (pattern, known) -> length(intersect(pattern, known[4])) == 4 && length(pattern) == 6
parser[6] = (pattern, known) -> length(intersect(pattern, known[1])) == 1 && length(pattern) == 6
parser[0] = (pattern, known) -> length(pattern) == 6
parser[3] = (pattern, known) -> length(intersect(pattern, known[7])) == 3
parser[5] = (pattern, known) -> length(intersect(pattern, known[4])) == 3
parser[2] = (pattern, known) -> true

function knowns(inputs)
    return map(segments -> begin
        # sorting by length ensures 1, 7 and 4 are inserted into `known` before they are needed
        # for subsequent comparisons
        sort!(segments, by = length)
        # patterns to try. order is important!
        todo = [1, 4, 7, 8, 9, 6, 0, 3, 5, 2]
        known = Dict{}()
        for pattern in segments
            for (i, x) in enumerate(todo)
                if parser[x](pattern, known)
                    known[x] = pattern
                    # no duplicates in inputs, so safe to remove once found
                    deleteat!(todo, i)
                    break
                end
            end
        end
        # sort strings and reverse dict
        Dict(reduce(*, sort(split(value, ""))) => key for (key, value) in known)
    end, inputs)
    
end

function score(line)
    (out, known) = line
    # sort strings in out to match knowns
    out = map(s -> reduce(*, sort(split(s, ""))), out)
    return reduce(+, [known[out[n]] * 10^(e - 1) for (n, e) in zip(4:-1:1, 1:4)])
end

ins = inputs(lines)
outs = outputs(lines)
known = knowns(ins)

p1 = length(filter(n -> length(n) in [2,3,4,7], vcat(outs...)))
p2 = sum(map(score, zip(outs, known)))

println("-----------------------------------------------------------------------")
println("seven segment search -- part one :: $p1")
println("seven segment search -- part two :: $p2")
println("-----------------------------------------------------------------------")

@assert(p1 == 452)
@assert(p2 == 1096964)
