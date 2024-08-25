allEqual :: Eq a => [a] -> Bool
allEqual [] = error "Error: Lista vacía"
allEqual [_]= error "Error: Lista con un solo elemento"
allEqual (x:xs) = all (== x) xs


main :: IO ()
main = do
    print (allEqual [1, 1])
    print (allEqual [1, 2])
    print (allEqual [1+2, 3])
    -- print (allEqual []) da error que no sabemos porqué.
    -- print (allEqual [1])