bests :: (a -> Double) -> [a] -> [a]
bests f xs = [ x | (x, y) <- (zip xs (map f xs)), (y == (maximum (map f xs))) ]