input = joinpath(@__DIR__, "input")
lines = readlines(input)

hex = lines[1]
bits = join(map(n -> string(parse(Int, n, base=16), base=2, pad=4), collect(hex)))

function version(bits)
    return parse(Int, bits[1:3], base=2)
end

function header(bits)
    return parse(Int, bits[4:6], base=2)
end

function packets(bits)
    m = parse(Int, bits[7], base=2)
    if m == 1
        return (1, parse(Int, bits[8:18], base=2))
    else
        return (0, parse(Int, bits[8:22], base=2))
    end
end

function val(bits)
    num = bits[7:end]
    acc = []
    i = 1
    while num[i] == '1'
        push!(acc, num[(i + 1):(i + 4)])
        i += 5
    end
    push!(acc, num[(i + 1):(i + 4)])
    rem = num[(i + 5):end]
    return (parse(Int, join(acc), base=2), rem)
end

function mode(bits)
    return parse(Int, bits[7], base=2)
end

function p(bits)
    all(c -> c == '0', collect(bits)) && return (0, 4, 0, [])
    v = version(bits)
    h = header(bits)
    if h == 4
        n, rem = val(bits)
        return (v, h, n, rem)
    else
        m = mode(bits)
        if m == 1
            acc = []
            _, l = packets(bits)
            rem = bits[19:end]
            while l > 0
                next = p(rem)
                push!(acc, next)
                rem = last(next)
                l -= 1
            end
            return (v, h, acc, rem)
        else
            acc = []
            _, l = packets(bits)
            bs = bits[23:(22 + l)]
            while !isempty(bs)
                next = p(bs)
                push!(acc, next)
                bs = last(next)
            end
            return (v, h, acc, bits[(23 + l):end])
        end
    end
end

pt = p(bits)

function versions(parsetree)
    (v, h, ps, _) = parsetree
    if isempty(ps) || h == 4
        return v
    else
        return v + sum(map(p -> versions(p), ps))
    end
end

function value(parsetree)
    (v, h, ps, _) = parsetree
    if h == 4
        return ps
    elseif h == 0
        return sum(map(value, ps))
    elseif h == 1
        return prod(map(value, ps))
    elseif h == 2
        return minimum(map(value, ps))
    elseif h == 3
        return maximum(map(value, ps))
    elseif h == 5
        vs = map(value, ps)
        vs[1] > vs[2] && return 1
        return 0
    elseif h == 6
        vs = map(value, ps)
        vs[1] < vs[2] && return 1
        return 0
    elseif h == 7
        vs = map(value, ps)
        vs[1] == vs[2] && return 1
        return 0
    end
end

p1 = versions(pt)
p2 = value(pt)

println("-----------------------------------------------------------------------")
println("packet decoder -- part one :: $p1")
println("packet decoder -- part two :: $p2")
println("-----------------------------------------------------------------------")

@assert(p1 == 843)
@assert(p2 == 5390807940351)
