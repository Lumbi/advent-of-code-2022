const fs = require('fs')

const shapeForSymbol = {
    'X': { 'A': 'C', 'B': 'A', 'C': 'B'},
    'Y': { 'A': 'A', 'B': 'B', 'C': 'C'},
    'Z': { 'A': 'B', 'B': 'C', 'C': 'A'},
}

const scoreForShape = {
    'A': 1,
    'B': 2,
    'C': 3
}

const scoreForOutcome = {
    'A': { 'A': 3, 'B': 6, 'C': 0},
    'B': { 'A': 0, 'B': 3, 'C': 6},
    'C': { 'A': 6, 'B': 0, 'C': 3},
}

const add = (a, b) => a + b
const sum = (array) => array.reduce(add, 0)

const input = fs.readFileSync('input.txt').toString()

const result = sum(
    input
        .split('\n')
        .map(line => line.split(' '))
        .map(([them, symbol]) => {
            const you = shapeForSymbol[symbol][them]
            return scoreForShape[you] + scoreForOutcome[them][you]
        })
)

console.log(result)
