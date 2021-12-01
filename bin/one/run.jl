using DelimitedFiles
using RollingFunctions

input = joinpath(@__DIR__, "input")
entries = readdlm(input, Int)

function depth(entries)
    return length(filter!(n -> n > 0, diff(entries)))
end

p1 = depth(vec(entries))
p2 = depth(rolling(sum, vec(entries), 3))

@assert(p1 == 1154)
@assert(p2 == 1127)

println("-----------------------------------------------------------------------")
println("sonar sweep -- part one :: $p1")
println("sonar sweep -- part two :: $p2")
println("-----------------------------------------------------------------------")