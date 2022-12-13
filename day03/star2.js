const fs = require('fs')

const pipe = (...fns) => x => fns.reduce((y, f) => f(y), x)
const add = (a, b) => a + b
const sum = (array) => array.reduce(add, 0)
const map = (f) => (array) => array.map(f)

const input = fs.readFileSync('input.txt').toString()

const chunk = (size) => (array) =>
    array.reduce((partial, next) => {
        const last = partial.pop()
        return last.length === size
            ? [...partial, last, [next]]
            : [...partial, [...last, next]]
    }, [[]])

const commonItem = (group) => {
    const firstGroup = group[0].split('')
    const secondGroup = group[1].split('')
    const thirdGroup = group[2].split('')
    return firstGroup.find((item) => secondGroup.includes(item) && thirdGroup.includes(item))
}

const priority = (item) => {
    const charCode = item.charCodeAt(0)
    return charCode >= 97
        ? charCode - 97 + 1
        : charCode - 65 + 27
}

const solve = pipe(
    chunk(3),
    map(pipe(commonItem, priority)),
    sum
)

const result = solve(input.split('\n'))

console.log(result)
