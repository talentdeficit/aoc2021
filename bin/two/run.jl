using Match

input = joinpath(@__DIR__, "input")
instructions = readlines(input)

instructions = map(instructions) do ins
    ins = split(ins)
    (first(ins), parse(Int, last(ins)))
end

function navigate(instructions, depth, pos)
    for i in instructions
        (op, val) = i 
        @match op begin
            "forward" => begin pos += val end
            "up" => begin depth -= val end
            "down" => begin depth += val end
        end
    end
    return depth * pos
end

function navigate(instructions, depth, pos, aim)
    for i in instructions
        (op, val) = i 
        @match op begin
            "forward" => begin
                pos += val
                depth += (val * aim)
            end
            "up" => begin aim -= val end
            "down" => begin aim += val end
        end
    end
    return depth * pos
end

p1 = navigate(instructions, 0, 0)
p2 = navigate(instructions, 0, 0, 0)

println("-----------------------------------------------------------------------")
println("dive! -- part one :: $p1")
println("dive! -- part two :: $p2")
println("-----------------------------------------------------------------------")

@assert(p1 == 1714680)
@assert(p2 == 1963088820)
