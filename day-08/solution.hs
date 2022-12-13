module Main where

import Data.List (transpose, concat)
import Control.Monad (liftM2)

phi :: (a -> b) -> (b -> c -> d) -> (a -> c) -> a -> d
phi = flip liftM2

matrixMap :: (a -> b) -> [[a]] -> [[b]]
matrixMap = map . map

matrixZip :: (a -> b -> c) -> [[a]] -> [[b]] -> [[c]]
matrixZip = zipWith . zipWith

solve :: (a -> a)      -- Transformation function that solves in one direction
      -> (a -> a -> a) -- Join results of solving in two directions
      -> (a -> a)      -- Transform into other direction
      -> a             -- Input
      -> a             -- Result
solve inside join surrounding = phi inside join (surrounding . inside . surrounding)

countVisible :: [Int] -> [Int]
countVisible = solve (count (-1)) (zipWith max) reverse
  where
    count :: Int -> [Int] -> [Int]
    count min (x:xs) | min < x = 1 : count x xs
    count min (x:xs)           = 0 : count min xs
    count min []               = []

part1 :: [[Int]] -> Int
part1 = sum . concat . solve (map countVisible) (matrixZip max) transpose

countPrefix :: (a -> Bool) -> [a] -> Int
countPrefix f (x:xs) | f x = 1 + countPrefix f xs
countPrefix f (_:xs) = 1
countPrefix _ _ = 0

scenicScore :: [Int] -> [Int]
scenicScore = solve (score []) (zipWith (*)) reverse
  where
    score :: [Int] -> [Int] -> [Int]
    score prev (x:xs)  = countPrefix (<x) prev : score (x:prev) xs
    score prev []     = []

part2 :: [[Int]] -> Int
part2 = maximum . concat . solve (map scenicScore) (matrixZip (*)) transpose

readInput :: IO [[Int]]
readInput = matrixMap (read . (:[])) . lines <$> readFile "input.txt"

main :: IO ()
main = readInput >>= phi (print . part1) (>>) (print . part2)

