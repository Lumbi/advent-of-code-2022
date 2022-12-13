const fs = require('fs')

const add = (a, b) => a + b
const sum = (array) => array.reduce(add, 0)
const max = (array) => array.sort()[array.length - 1]

const input = fs.readFileSync('input.txt').toString()

const result = max(
    input
        .split('\n')
        .map(line => line == "" ? undefined : Number(line))
        .reduce((partial, next) =>
            next === undefined
                ? [...partial, []]
                : [...partial.slice(0, -1), [...partial[partial.length -1], next]]
        , [[]])
        .map(sum)
)

console.log(result)
