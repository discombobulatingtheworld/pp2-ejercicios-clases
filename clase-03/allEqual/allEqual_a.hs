allEqual :: (Eq a) => [a] -> Bool
allEqual xs
    | (length xs) < 2 = error "La lista debe contener 2 o mas elementos."
    | (length xs) >= 2 = all (== (head xs)) (tail xs)