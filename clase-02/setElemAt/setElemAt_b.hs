setElemAt :: [a] -> a -> Int -> [a]

_setElemAt :: [a] -> [a] -> a -> Int -> [a]

_setElemAt returnList remainingList insertedElement index
    | length returnList == index = returnList ++ [insertedElement] ++ drop 1 remainingList
    | null remainingList = returnList
    | otherwise = _setElemAt (returnList ++ [head remainingList]) (drop 1 remainingList) insertedElement index

setElemAt list insertedElement index
    | length list < index = error "error \"!\""
    | index == 0 = insertedElement : drop 1 list
    | otherwise = _setElemAt [head list] (drop 1 list) insertedElement index

main :: IO ()
main = do
    print "Resultado 1:"
    let resultado1 = setElemAt [1,2,3] 77 1
    print resultado1
    print "Resultado 2:"
    let resultado2 = setElemAt "abcdef" 'x' 0
    print resultado2
    print "Resultado 3:"
    let resultado3 = setElemAt "abcdef" 'x' 2
    print resultado3
    print "Resultado 4:"
    let resultado4 = setElemAt "abcdef" 'x' 5
    print resultado4
    print "Resultado 5:"
    let resultado5 = setElemAt [0,1,2,3] 1 (-1)
    print resultado5
    print "Resultado 6:"
    let resultado6 = setElemAt [] True 0
    print resultado6
    print "Resultado 7:" -- Da error
    let resultado7 = setElemAt [] True 1
    print resultado7
    print "Resultado 8:" -- Da error
    let resultado8 = setElemAt [False,True] False 3
    print resultado8
