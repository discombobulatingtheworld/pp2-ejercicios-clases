fibonacci :: Integer -> Integer
fibonacci num
    | num < 0 = error "Numero negativo!"
    | num == 0 = 0
    | num == 1 = 1
    | num >= 2 = ( ( fibonacci (num - 1) ) + ( fibonacci (num - 2)) )