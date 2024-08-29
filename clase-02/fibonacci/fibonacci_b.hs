--
fibonacciStep :: (Integer, Integer) -> (Integer,Integer)
fibonacciStep (x,y) = (y,x+y) -- Realiza la función que aumenta

-- Va hacia el principio de fibonacci, una vez llega a 0 otorga la tupla inicial, luego reconstruye hasta llegar a n.
fibonacciPair :: Integer -> (Integer,Integer)
fibonacciPair n = if n == 0 then (0,1) else if n < 0 then error "Error: Fibonacci no funciona para negativos" else fibonacciStep (fibonacciPair (n-1))

fibonacci :: Integer -> Integer
fibonacci = fst.fibonacciPair -- fst retorna la primera instancia de una tupla de dos valores

main :: IO ()
main = do
    let resultado1 = fibonacci 0
    print resultado1
    let resultado2 = fibonacci 1
    print resultado2
    let resultado3 = fibonacci 2
    print resultado3
    let resultado4 = fibonacci 3
    print resultado4
    let resultado5 = fibonacci 5
    print resultado5
    let resultado6 = fibonacci 7
    print resultado6
    let resultado6 = fibonacci 10
    print resultado6
    let resultado7 = fibonacci (-1)
    print resultado7
