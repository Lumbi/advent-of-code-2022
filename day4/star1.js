const fs = require('fs')
const input = fs.readFileSync('input.txt').toString()

const pipe = (...fns) => x => fns.reduce((y, f) => f(y), x)
const map = (f) => (array) => array.map(f)
const count = (array) => array.length
const filter = (f) => (array) => array.filter(f)
const split = (c) => (s) => s.split(c)

const parseRange = (string) => {
    const parts = string.split('-')
    return { start: Number(parts[0]), end: Number(parts[1]) }
}

const parseLine = (string) => {
    const rangeStrings = string.split(',')
    return [parseRange(rangeStrings[0]), parseRange(rangeStrings[1])]
}

const rangeContains = (range, other) => range.start <= other.start && range.end >= other.end

const rangeContainsOtherInPair = (ranges) => rangeContains(ranges[0], ranges[1]) || rangeContains(ranges[1], ranges[0])

const solve = pipe(
    split('\n'),
    map(pipe(parseLine, rangeContainsOtherInPair)),
    filter(a => a === true),
    count
)

const result = solve(input)

console.log(result)
