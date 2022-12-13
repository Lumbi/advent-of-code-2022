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

pop :: Int -> [a] -> [a]
pop _ [] = []
pop count list = take ((length list) - count) list

top :: Int -> [a] -> [a]
top _ [] = []
top count list = drop ((length list) - count) list

movePackages :: [[Char]] -> (Int, Int, Int) -> [[Char]]
movePackages stacks (from, to, count) =
    map
    (\(i, stack) -> if
        | i == from -> pop count stack
        | i == to -> stack ++ top count (stacks!!from)
        | otherwise -> stack
    )
    (zip [0..] stacks)

solve :: String -> String
solve =
    lines >>>
    map parseLine >>>
    foldl movePackages initialStacks >>>
    map last

main :: IO ()
main = do {
    input <- readFile "input.txt"
    ;
    print (solve input)
}
