# Ejemplo A

## Respuestas

### Pregunta 1

```haskell
import Data.Char (isDigit)


_operator2 :: Num a => (a -> a -> a) -> [a] -> [a]
_operator2 op list = if length list >= 2 then op n2 n1:ns else error "Sin suficientes elementos"
    where (n1:n2:ns) = list

_operator1 :: Num a => (a -> a) -> [a] -> [a]
_operator1 op list = if length list >= 1 then op n1:ns else error "Sin suficientes elementos"
    where (n1:ns) = list


operator :: Char -> ([Double] -> [Double])
operator ch
    | isDigit ch = \ns -> (read [ch] :: Double):ns
    | ch == '+' = _operator2 (+)
    | ch == '-' = _operator2 (-)
    | ch == '*' = _operator2 (*)
    | ch == '/' = _operator2 (/)
    | ch == '^' = _operator2 (**)
    | ch == '~' = _operator1 (*(-1))
    | ch == 'p' = \ns -> [ if i == 0 then pi else ns!!i  | i <- [0..(length ns)] ]
    | otherwise = error "Operador no soportado!"


evaluate :: String -> [Double]
evaluate "" = []
evaluate str = foldl (flip operator) [] str


test1 = evaluate "2~"
test2 = evaluate "23^"
test3 = evaluate "212/^"
test4 = evaluate "p2*"
```

#### Devolución

El operador pi falla si la pila de evaluación no está vacía. El resto es coherente.

### Pregunta 2

```haskell
import Data.Char (isDigit)

numbers :: String -> String
numbers = filter isDigit


test1 = numbers ""
test2 = numbers "abcd"
test3 = numbers "[3,2,1]"
test4 = numbers "0n3 tw0 thr33"
```

#### Devolución

Correcto.

### Pregunta 3

d. Ninguna de las otras opciones son correctas.

#### Devolución

Ok.