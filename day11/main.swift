import Foundation

typealias WorryLevel = Decimal
typealias MonkeyIndex = Int
typealias Operation = (WorryLevel) -> (WorryLevel)
typealias Test = (WorryLevel) -> (MonkeyIndex)

extension Decimal {
    func rounded(_ roundingMode: NSDecimalNumber.RoundingMode = .down) -> Decimal {
        var result = Decimal()
        var number = self
        NSDecimalRound(&result, &number, 0, roundingMode)
        return result
    }

    var whole: Decimal { rounded(sign == .minus ? .up : .down) }

    var fraction: Decimal { self - whole }

    func divisible(by int: Int) -> Bool {
        var result = Decimal()
        var dividend = self
        var divisor = Decimal(int)
        let error = NSDecimalDivide(&result, &dividend, &divisor, .up)
        if error != .noError { fatalError() }
        return result.fraction.isZero
    }

    func mod(_ int: Int) -> Self {
        var result = Decimal()
        var dividend = self
        var divisor = Decimal(int)
        let error = NSDecimalDivide(&result, &dividend, &divisor, .down)
        if error != .noError { fatalError() }
        return self - (result.rounded() * divisor)
    }
}

class Monkey {
    let index: MonkeyIndex
    private(set) var items: [WorryLevel]
    private(set) var inspectionCount: UInt = 0
    private let operation: Operation
    private let test: Test

    init(
        index: MonkeyIndex,
        startingItems: [WorryLevel],
        operation: @escaping Operation,
        test: @escaping Test
    ) {
        self.index = index
        self.items = startingItems
        self.operation = reduce(operation)
        self.test = test
    }

    func throwNext() -> (MonkeyIndex, WorryLevel)? {
        if let item = items.first {
            inspectionCount += 1
            let updatedItem = operation(item)
            let nextMonkey = test(updatedItem)
            items.removeFirst()
            return (nextMonkey, updatedItem)
        } else {
            return nil
        }
    }

    func receive(_ item: WorryLevel) {
        items.append(item)
    }
}

var REDUCE_WORRY: ReduceWorry = .divideByThree

enum ReduceWorry {
    case divideByThree
    case modulo
}

func reduce(_ operation: @escaping Operation) -> Operation {
    { worryLevel in
        switch REDUCE_WORRY {
            case .divideByThree:
                var result = Decimal()
                var number = (operation(worryLevel) / 3).rounded()
                NSDecimalRound(&result, &number, 0, .down)
                return result
            case .modulo:
                let reducedWorryLevel = worryLevel.mod(2*3*5*7*11*13*17*19*23)
                return operation(reducedWorryLevel)
        }
    }
}

func createMonkeys() -> [Monkey] {
    [
        Monkey(
            index: 0,
            startingItems: [65, 78],
            operation: { $0 * 3 },
            test: { $0.divisible(by: 5) ? 2 : 3 }
        ),
        Monkey(
            index: 1,
            startingItems: [54, 78, 86, 79, 73, 64, 85, 88],
            operation: { $0 + 8 },
            test: { $0.divisible(by: 11) ? 4 : 7 }
        ),
        Monkey(
            index: 2,
            startingItems: [69, 97, 77, 88, 87],
            operation: { $0 + 2 },
            test: { $0.divisible(by: 2) ? 5 : 3 }
        ),
        Monkey(
            index: 3,
            startingItems: [99],
            operation: { $0 + 4 },
            test: { $0.divisible(by: 13) ? 1 : 5 }
        ),
        Monkey(
            index: 4,
            startingItems: [60, 57, 52],
            operation: { $0 * 19 },
            test: { $0.divisible(by: 7) ? 7 : 6 }
        ),
        Monkey(
            index: 5,
            startingItems: [91, 82, 85, 73, 84, 53],
            operation: { $0 + 5 },
            test: { $0.divisible(by: 3) ? 4 : 1 }
        ),
        Monkey(
            index: 6,
            startingItems: [88, 74, 68, 56],
            operation: { $0 * $0 },
            test: { $0.divisible(by: 17) ? 0 : 2 }
        ),
        Monkey(
            index: 7,
            startingItems: [54, 82, 72, 71, 53, 99, 67],
            operation: { $0 + 1 },
            test: { $0.divisible(by: 19) ? 6 : 0 }
        ),
    ]
}

func simulate(monkeys: [Monkey], rounds: UInt) -> UInt {
    for _ in 1...rounds {
        for monkey in monkeys {
            while let next = monkey.throwNext() {
                let (nextMonkey, item) = next
                monkeys[nextMonkey].receive(item)
            }
        }
    }

    let monkeyBusiness = monkeys.map(\.inspectionCount).sorted(by: { $0 > $1 }).prefix(2).reduce(1 , *)
    return monkeyBusiness
}

REDUCE_WORRY = .divideByThree

print("star1: \(simulate(monkeys: createMonkeys(), rounds: 20))")

REDUCE_WORRY = .modulo

print("star2: \(simulate(monkeys: createMonkeys(), rounds: 10000))")
