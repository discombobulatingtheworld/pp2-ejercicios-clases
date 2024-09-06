import Data.Char (isDigit)


_operator :: Num a => (a -> a -> a) -> [a] -> [a]
_operator op list = if length list >= 2 then op n1 n2:ns else error "Sin suficientes elementos"
    where (n1:n2:ns) = list


operator :: Char -> ([Double] -> [Double])
operator ch
    | isDigit ch = \ns -> (read [ch] :: Double):ns
    | ch == '+' = _operator (+)
    | ch == '-' = _operator (-)
    | ch == '*' = _operator (*)
    | ch == '/' = _operator (/)
    | otherwise = error "Operador no soportado!"


evaluate :: String -> [Double]
evaluate "" = []
evaluate str = foldl (flip operator) [] str