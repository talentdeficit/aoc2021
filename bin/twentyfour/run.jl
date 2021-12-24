using Match

input = joinpath(@__DIR__, "input")
lines = readlines(input)

DEBUG = false

function decode(lines)
    acc = []
    for line in lines
        @match line[1:3] begin
            "inp" => push!(acc, (:inp, line[5]))
            "add" => push!(acc, (:add, line[5], line[7:end]))
            "mul" => push!(acc, (:mul, line[5], line[7:end]))
            "div" => push!(acc, (:div, line[5], line[7:end]))
            "mod" => push!(acc, (:mod, line[5], line[7:end]))
            "eql" => push!(acc, (:eql, line[5], line[7:end]))
        end
    end
    return acc
end

function adder(registers, a, b)
    rs = copy(registers)
    if first(b) in ['w', 'x', 'y', 'z']
        rs[a] = rs[a] + rs[first(b)]
    else
        rs[a] = rs[a] + parse(Int, b)
    end
    return rs
end

function multiplier(registers, a, b)
    rs = copy(registers)
    if first(b) in ['w', 'x', 'y', 'z']
        rs[a] = rs[a] * rs[first(b)]
    else
        rs[a] = rs[a] * parse(Int, b)
    end
    return rs
end

function divider(registers, a, b)
    rs = copy(registers)
    if first(b) in ['w', 'x', 'y', 'z']
        rs[a] = floor(rs[a] / rs[first(b)])
    else
        rs[a] = floor(rs[a] / parse(Int, b))
    end
    return rs
end

function modder(registers, a, b)
    rs = copy(registers)
    if first(b) in ['w', 'x', 'y', 'z']
        rs[a] = rem(rs[a], rs[first(b)])
    else
        rs[a] = rem(rs[a], parse(Int, b))
    end
    return rs
end

function equaler(registers, a, b)
    rs = copy(registers)
    if first(b) in ['w', 'x', 'y', 'z']
        if rs[a] == rs[first(b)]
            rs[a] = 1
        else
            rs[a] = 0
        end
    else
        if rs[a] == parse(Int, b)
            rs[a] = 1
        else
            rs[a] = 0
        end
    end
    return rs
end

# generic vm. slow as shit. use runf below
function run(program, registers, input, io)
    idx = io
    for int in program
        @match first(int) begin
            :inp => begin
                _, register = int
                registers[register] = parse(Int, input[idx])
                idx += 1
                DEBUG && println("$int :: $io :: $registers")
            end
            :add => begin
                _, a, b = int
                registers = adder(registers, a, b)
                DEBUG && println("$int :: $io :: $registers")
            end
            :mul => begin
                _, a, b = int
                registers = multiplier(registers, a, b)
                DEBUG && println("$int :: $io :: $registers")
            end
            :div => begin
                _, a, b = int
                registers = divider(registers, a, b)
                DEBUG && println("$int :: $io :: $registers")
            end
            :mod => begin
                _, a, b = int
                registers = modder(registers, a, b)
                DEBUG && println("$int :: $io :: $registers")
            end
            :eql => begin
                _, a, b = int
                registers = equaler(registers, a, b)
                DEBUG && println("$int :: $io :: $registers")
            end
        end
    end
    return registers
end

# optimized version of the program. doesn't take a year to finish
function runf(program, rs, input, i)
    rs = copy(rs)
    w = parse(Int, input[i])
    mode = parse(Int, last(program[5]))
    check = parse(Int, last(program[6]))
    offset = parse(Int, last(program[16]))

    z = rs['z']
    x = rem(z, 26) + check
    z = Int(floor(z / mode))
    if x != w
        rs['z'] = 26 * z + w + offset
    else
        rs['z'] = z
    end
    return rs
end

PROGRAM = decode(lines)
INITIAL = Dict([('w', 0), ('x', 0), ('y', 0), ('z', 0)])

function optimize(f)
    candidates = Dict([([], 0)])

    # 14 inputs
    for i in 1:14
        baseline = minimum(values(candidates))
        program = PROGRAM[((18 * (i - 1)) + 1):(18 * i)]
        digits = map(string, 1:9)
        definitely = Dict()
        maybe = Dict()
        for (candidate, z) in collect(candidates)
            for digit in digits
                rs = copy(INITIAL)
                rs['z'] = z
                input = string(collect(candidate)...) * digit
                result = f(program, rs, input, i)
                nz = result['z']
                # @show((input, nz, baseline, nz < baseline))
                if nz < baseline
                    definitely[input] = nz
                elseif isempty(definitely)
                    maybe[input] = nz
                end
            end
        end
        if !isempty(definitely)
            candidates = definitely
        else
            candidates = maybe
        end
    end

    filter!(kv -> last(kv) == 0, candidates)
    return extrema(map(n -> parse(Int, n), collect(keys(candidates))))
end

# pass in run instead of runf to verify correctness
p2, p1 = optimize(runf)

println("-----------------------------------------------------------------------")
println("arithmetic logic unit -- part one :: $p1")
println("arithmetic logic unit -- part two :: $p2")
println("-----------------------------------------------------------------------")

@assert(p1 == 52926995971999)
@assert(p2 == 11811951311485)
