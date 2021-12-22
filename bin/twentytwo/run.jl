input = joinpath(@__DIR__, "input")
lines = readlines(input)

function cubes(lines)
    acc = []
    for line in lines
        mode = startswith(line, "on") ? true : false
        l, r = parse.(Int, match(r"x=([-]?\d+)..([-]?\d+)", line).captures)
        xi = min(l, r) 
        xa = max(l, r)
        l, r = parse.(Int, match(r"y=([-]?\d+)..([-]?\d+)", line).captures)
        yi = min(l, r)
        ya = max(l, r)
        l, r = parse.(Int, match(r"z=([-]?\d+)..([-]?\d+)", line).captures)
        zi = min(l, r)
        za = max(l, r)
    
        cube = (mode, xi:xa, yi:ya, zi:za)
    
        push!(acc, cube)
    end
    return acc
end

function boundcheck(cube)
    (_, x, y, z) = cube
    return issubset(x, -50:50) && issubset(y, -50:50) && issubset(z, -50:50)
end

function flip(switches)
    acc = Set()
    for cube in switches
        (mode, x, y, z) = cube
        for switch in collect(Iterators.product(x, y, z))
            if mode
                push!(acc, switch)
            else
                delete!(acc, switch)
            end
        end
    end
    return acc
end

function expand(cubes)
    acc = []
    for cube in cubes
        (emode, ex, ey, ez) = cube
        nacc = []
        for (nmode, nx, ny, nz) in acc
            x = intersect(ex, nx)
            y = intersect(ey, ny)
            z = intersect(ez, nz)
            if length(x) > 0 && length(y) > 0 && length(z) > 0
                push!(nacc, (!nmode, x, y, z))
            end
        end
        if emode
            push!(nacc, cube)
        end
        append!(acc, nacc)
    end
    return acc
end

function value(cube)
    (mode, x, y, z) = cube
    n = length(x) * length(y) * length(z)
    return mode ? n : -1 * n
end

cs = cubes(lines)
cs = filter(boundcheck, cs)
p1 = length(flip(cs))

cs = cubes(lines)
cs = expand(cs)
p2 = sum(value, cs)

println("-----------------------------------------------------------------------")
println("reactor reboot -- part one :: $p1")
println("reactor reboot -- part two :: $p2")
println("-----------------------------------------------------------------------")

@assert(p1 == 567496)
@assert(p2 == 1355961721298916)