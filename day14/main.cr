input = File.read("input.txt")

ROCK = '#'
SAND = '@'

alias Point = {x: Int32, y: Int32}

SAND_START = {x: 500, y: 0}

def create_world(input)
    world = {} of Point => Char

    rocks = input
        .each_line
        .map { |line|
            edges = line
                .split(" -> ")
                .map { |string| string.split(',') }
                .map { |parts| { x: parts[0].to_i, y: parts[1].to_i } }

            edges.skip(1).zip(edges)
                .map { |a, b|
                    range_x = (Math.min(a[:x], b[:x]) .. Math.max(a[:x], b[:x])).to_a
                    range_y = (Math.min(a[:y], b[:y]) .. Math.max(a[:y], b[:y])).to_a

                    next range_x.each_cartesian(range_y).map { |(x,y)| { x: x, y: y } }
                }
                .flatten
        }
        .flatten

    rocks.each do |point|
        world[point] = ROCK
    end

    world[SAND_START] = '+'

    return world
end

def show(world)
    min_x = world.each_key.map { |p| p[:x] }.min
    max_x = world.each_key.map { |p| p[:x] }.max
    min_y = 0
    max_y = world.each_key.map { |p| p[:y] }.max

    puts "\t" + "-" * (max_x - min_x)

    (min_y..max_y).each do |y|
        line = y.to_s + "\t"
        (min_x..max_x).each do |x|
            if what = world[{x: x, y: y}]?
                line += what
            else
                line += ' '
            end
        end
        puts line
    end
end

def drop_sand1(world, bounds_y)
    out_of_bounds = false

    sand = SAND_START
    while true
        down = { x: sand[:x], y: sand[:y] + 1 }
        left = { x: sand[:x] - 1, y: sand[:y] + 1 }
        right = { x: sand[:x] + 1, y: sand[:y] + 1 }

        out_of_bounds = down[:y] > bounds_y
        if out_of_bounds
            break
        elsif world[down]?.nil?
            world.delete(sand)
            world[down] = SAND
            sand = down
        elsif world[left]?.nil?
            world.delete(sand)
            world[left] = SAND
            sand = left
        elsif world[right]?.nil?
            world.delete(sand)
            world[right] = SAND
            sand = right
        else
            break # not moving
        end
    end

    return out_of_bounds
end

def drop_sand2(world, bounds_y)
    floor = bounds_y + 2

    sand = SAND_START
    world[sand] = SAND

    while true
        down = { x: sand[:x], y: sand[:y] + 1 }
        left = { x: sand[:x] - 1, y: sand[:y] + 1 }
        right = { x: sand[:x] + 1, y: sand[:y] + 1 }

        if on_floor = down[:y] >= floor
            break
        elsif world[down]?.nil?
            world.delete(sand)
            world[down] = SAND
            sand = down
        elsif world[left]?.nil?
            world.delete(sand)
            world[left] = SAND
            sand = left
        elsif world[right]?.nil?
            world.delete(sand)
            world[right] = SAND
            sand = right
        else
            break # not moving
        end
    end
end

def simulate(world, star)
    count = 0
    bounds_y = world.each_key.map { |p| p[:y] }.max
    while true
        if star == 1
            if out_of_bounds = drop_sand1(world, bounds_y)
                break
            else
                count += 1
            end

        elsif star == 2
            drop_sand2(world, bounds_y)
            count += 1
            if world[SAND_START]? == SAND
                break
            end

        end
    end

    puts("star#{star}: #{count}")
end

simulate(create_world(input), 1)

simulate(create_world(input), 2)
