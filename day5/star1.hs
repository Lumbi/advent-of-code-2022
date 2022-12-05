{-# LANGUAGE MultiWayIf #-}

import Prelude
import Text.Read
import Data.Maybe
import Data.List
import Control.Arrow

initialStacks :: [[Char]]
initialStacks =
    [
        ['D', 'L', 'V', 'T', 'M', 'H', 'F'],
        ['H', 'Q', 'G', 'J', 'C', 'T', 'N', 'P'],
        ['R', 'S', 'D', 'M', 'P', 'H'],
        ['L', 'B', 'V', 'F'],
        ['N', 'H', 'G', 'L', 'Q'],
        ['W', 'B', 'D', 'G', 'R', 'M', 'P'],
        ['G', 'M', 'N', 'R', 'C', 'H', 'L', 'Q'],
        ['C', 'L', 'W'],
        ['R', 'D', 'L', 'Q', 'J', 'Z', 'M', 'T']
    ]

parseLine :: String -> (Int, Int, Int)
parseLine line = (from - 1, to - 1, count)
    where [count, from, to] = mapMaybe readMaybe (words line)

pop :: [a] -> [a]
pop [] = []
pop list = init list

top :: [a] -> [a]
top [] = []
top list = [last list]

movePackage :: [[Char]] -> (Int, Int) -> [[Char]]
movePackage stacks (from, to) =
    map
    (\(i, stack) -> if
        | i == from -> pop stack
        | i == to -> stack ++ top (stacks!!from)
        | otherwise -> stack
    )
    (zip [0..] stacks)

repeatMovePackage :: [[Char]] -> (Int, Int, Int) -> [[Char]]
repeatMovePackage stacks (_, _, 0) = stacks
repeatMovePackage stacks (from, to, n) = repeatMovePackage (movePackage stacks (from, to)) (from, to, n - 1)

solve :: String -> String
solve =
    lines >>>
    map parseLine >>>
    foldl repeatMovePackage initialStacks >>>
    map last

main :: IO ()
main = do {
    input <- readFile "input.txt"
    ;
    print (solve input)
}
