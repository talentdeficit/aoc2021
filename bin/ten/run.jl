using Match

input = joinpath(@__DIR__, "input")
lines = readlines(input)

lines = map(line -> collect(line), lines)

function evalue(line)
    seen = []
    while length(line) > 0
        curr = popfirst!(line)
        @match curr begin
            ')' => pop!(seen) != '(' && return 3
            ']' => pop!(seen) != '[' && return 57
            '}' => pop!(seen) != '{' && return 1197
            '>' => pop!(seen) != '<' && return 25137
            otherwise => push!(seen, otherwise)
        end
    end
    return 0
end

function remvalue(line)
    seen = []
    while length(line) > 0
        curr = popfirst!(line)
        @match curr begin
            ')' => pop!(seen) != '(' && return nothing
            ']' => pop!(seen) != '[' && return nothing
            '}' => pop!(seen) != '{' && return nothing
            '>' => pop!(seen) != '<' && return nothing
            otherwise => push!(seen, otherwise)
        end
    end
    return seen
end

function score(line)
    acc = 0
    while length(line) > 0
        acc *= 5
        curr = pop!(line)
        if curr == '('
            acc += 1
        elseif curr == '['
            acc += 2
        elseif curr == '{'
            acc += 3
        elseif curr == '<'
            acc += 4
        end
    end
    return acc
end

p1 = sum(map(evalue, deepcopy(lines)))

scores = sort(map(score, filter(!isnothing, map(remvalue, deepcopy(lines)))))
midpoint = div(length(scores), 2) + 1
p2 = scores[midpoint]

println("-----------------------------------------------------------------------")
println("syntax scoring -- part one :: $p1")
println("syntax scoring -- part two :: $p2")
println("-----------------------------------------------------------------------")

@assert(p1 == 243939)
@assert(p2 == 2421222841)
