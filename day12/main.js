const fs = require('fs')

const input = fs.readFileSync('input.txt').toString()

const map = input.split('\n').map(line => line.split(''))

function at(map, point) { return map[point.y][point.x] }

function start(map) {
    for (y = 0; y < map.length; y++) {
        for (x = 0; x < map[0].length; x++) {
            if (at(map, { x, y }) == 'S') {
                return { x , y}
            }
        }
    }
}

function inside(map, point) { return point.y >= 0 && point.y < map.length && point.x >= 0 && point.x < map[0].length }

function visited(trail, point) { return trail.find(p => p.x == point.x && p.y == point.y) !== undefined }

function elevation(map, point) {
    const symbol = at(map, point)
    switch (symbol) {
        case 'S': return 96
        case 'E': return 123
        default: return symbol.charCodeAt(0)
    }
}

function visitable(map, from, to) {
    return inside(map, to) && (elevation(map, to) - elevation(map, from) - 1 <= 0)
}

function find_path(map, start, isGoal) {
    const root = start
    const explored = []
    const explore_queue = []

    explore_queue.push(root)
    explored.push(root)

    while (explore_queue.length > 0) {
        const current = explore_queue.pop()
        if (isGoal(at(map, current))) {
            return current
        } else {
            const up = { ...current, y: current.y + 1 }
            const down = { ...current, y: current.y - 1 }
            const left = { ...current, x: current.x - 1 }
            const right = { ...current, x: current.x + 1 }

            for (step of [up, down, left, right]) {
                if (visitable(map, current, step) && !visited(explored, step)) {
                    explored.push(step)
                    step.parent = current
                    explore_queue.unshift(step)
                }
            }
        }
    }
}

function length(path) {
    if (!path) { return -1 }
    let node = path
    let length = 0
    while (node != undefined) {
        node = node.parent
        length += 1
    }
    return length
}

function star1() {
    const path = find_path(map, start(map), c => c == 'E')
    console.log("star1:", length(path) - 1)
}

function star2() {
    let shortest_length = Number.MAX_VALUE
    for (y = 0; y < map.length; y++) {
        for (x = 0; x < map[0].length; x++) {
            const current = { x, y }
            if (at(map, current) == 'a' || at(map, current) == 'S') {
                const path = find_path(map, current, (c => c == 'E'))
                if (path) {
                    const path_length = length(path)
                    if (path_length < shortest_length) {
                        shortest_length = path_length
                    }
                }
            }
        }
    }
    console.log("star2:", shortest_length - 1)
}

star1()

star2()
