bests :: (a -> Double) -> [a] -> [a]
bests f xs = [ x | (x, y) <- (zip xs evals), (y == maxEval) ]
    where 
        evals = map f xs
        maxEval = maximum evals