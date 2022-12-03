const fs = require('fs')

const pipe = (...fns) => x => fns.reduce((y, f) => f(y), x)
const add = (a, b) => a + b
const sum = (array) => array.reduce(add, 0)

const input = fs.readFileSync('input.txt').toString()

const findDuplicate = (rucksack) => {
    const half = rucksack.length / 2
    const compartment1 = rucksack.split('').slice(0, half)
    const compartment2 = rucksack.split('').slice(half)
    const duplicate = compartment1.find(item => compartment2.includes(item))
    return duplicate
}

const priority = (item) => {
    const charCode = item.charCodeAt(0)
    return charCode >= 97
        ? charCode - 97 + 1
        : charCode - 65 + 27
}

const result = sum(
    input
        .split('\n')
        .map(pipe(findDuplicate, priority))
)

console.log(result)
