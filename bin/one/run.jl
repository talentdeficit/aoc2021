using DelimitedFiles

input = joinpath(@__DIR__, "input")
entries = readdlm(input, Int)

function depth(entries)
    acc = 0
    for i in 1:(length(entries) - 1)
        if entries[i] < entries[i + 1]
            acc += 1
        end
    end

    return acc
end

function windowed_depth(entries)
    acc = 0
    for i in 1:(length(entries) - 3)
        if sum(entries[i:i + 2]) < sum(entries[i + 1:i + 3])
            acc += 1
        end
    end

    return acc
end

p1 = depth(entries)
p2 = windowed_depth(entries)

@assert(p1 == 1154)
@assert(p2 == 1127)

println("-----------------------------------------------------------------------")
println("sonar sweep -- part one :: $p1")
println("sonar sweep -- part two :: $p2")
println("-----------------------------------------------------------------------")