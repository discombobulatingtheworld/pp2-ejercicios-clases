import Data.Char (isDigit)

operator :: Char -> ([Double] -> [Double])
operator ch 
    | (isDigit ch) = (\ns -> (read [ch]):ns)
    | (ch == '+') = (\(n1:n2:ns) -> (n1 + n2):ns)
    | (ch == '-') = (\(n1:n2:ns) -> (n1 - n2):ns)
    | (ch == '*') = (\(n1:n2:ns) -> (n1 * n2):ns)
    | (ch == '/') = (\(n1:n2:ns) -> (n1 / n2):ns)
    | otherwise = error "Operador no soportado!"