const fs = require('fs')

const scoreForShape = {
    'X': 1,
    'Y': 2,
    'Z': 3
}

const scoreForOutcome = {
    'A': { 'X': 3, 'Y': 6, 'Z': 0},
    'B': { 'X': 0, 'Y': 3, 'Z': 6},
    'C': { 'X': 6, 'Y': 0, 'Z': 3},
}

const add = (a, b) => a + b
const sum = (array) => array.reduce(add, 0)

const input = fs.readFileSync('input.txt').toString()

const result = sum(
    input
        .split('\n')
        .map(line => line.split(' '))
        .map(([them, you]) => scoreForShape[you] + scoreForOutcome[them][you])
)

console.log(result)
