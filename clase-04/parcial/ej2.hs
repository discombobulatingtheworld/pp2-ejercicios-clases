import Data.Char (isDigit)

numbers :: String -> String
numbers = filter isDigit


test1 = numbers ""
test2 = numbers "abcd"
test3 = numbers "[3,2,1]"
test4 = numbers "0n3 tw0 thr33"