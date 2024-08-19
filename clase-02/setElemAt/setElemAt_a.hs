setElemAt :: [a] -> a -> Int -> [a]
setElemAt original member index
    | (index < 0) = error "Negative index not supported."
    | ((length original) < index) = error "Index beyond length of list."
    | ((length original) == index) = original++[member]
    | (((length original) > index) && (index >= 0)) = [(if (current == index) then member else original !! current) | current <- [0..((length original) - 1)] ]
