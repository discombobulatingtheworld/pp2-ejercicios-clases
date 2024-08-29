oneHot :: Int -> Int -> [Int]

_oneHot :: [Int] -> Int -> Int -> [Int]
_oneHot list a b
  | length list == a = list
  | length list == b = _oneHot (list ++ [1]) a b
  | otherwise = _oneHot (list ++ [0]) a b

oneHot a b
  | a < 0 = error "error!" 
  | otherwise = _oneHot [] a b

main :: IO ()
main = do
  print "Resultado 1:"
  let resultado1 = oneHot 0 0
  print resultado1
  print "Resultado 2:"
  let resultado2 = oneHot 3 0
  print resultado2
  print "Resultado 3:"
  let resultado3 = oneHot 4 2
  print resultado3
  print "Resultado 4:"
  let resultado4 = oneHot 2 (-1)
  print resultado4
  print "Resultado 5:"
  let resultado5 = oneHot 5 7
  print resultado5
  print "Resultado 6:"
  let resultado6 = oneHot (-1) 2
  print resultado6