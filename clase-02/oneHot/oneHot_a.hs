oneHot :: Integer -> Integer -> [Integer]
oneHot len idx
    | (len < 0) = error "Length can't be negative!"
    | (len >= 0) = [if curr == idx then 1 else 0 | curr <- [0..(len - 1)]]