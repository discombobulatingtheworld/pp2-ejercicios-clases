inRange :: Integer -> Integer -> Integer -> Bool
inRange lowerLim upperLim value = (if lowerLim <= value && value <= upperLim then True else False)

main :: IO ()
main = do
  let resultado1 = inRange 5 7 1 -- False
  print resultado1
  let resultado2 = inRange 5 7 6 -- True
  print resultado2
  let resultado3 = inRange 5 7 8 -- False
  print resultado3
  let resultado4 = inRange 5 7 5 -- True
  print resultado4
  let resultado5 = inRange 7 5 6 -- False
  print resultado5
  let resultado6 = inRange (-1) 0 2 -- False
  print resultado6
  let resultado7 = inRange (-1) 1 0 -- True
  print resultado7
  