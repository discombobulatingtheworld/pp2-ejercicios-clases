data AExp = Num Int | Var String
          | Add AExp AExp | Sub AExp AExp
          | Mult AExp AExp deriving (Eq, Show)
data BExp = BoolLit Bool
          | CompEq AExp AExp | CompLtEq AExp AExp
          | Neg BExp | And BExp BExp deriving (Eq, Show)
data Stmt = Assign String AExp
          | Seq [Stmt]
          | IfThenElse BExp Stmt Stmt
          | WhileDo BExp Stmt deriving (Eq, Show)
skip = Seq []

type State = [(String, Int)]

evalAExp :: AExp -> State -> Int
evalAExp (Num n) _ = n
evalAExp (Var x) s = let (Just v) = lookup x s in v
evalAExp (Add a1 a2) s = evalAExp a1 s + evalAExp a2 s
evalAExp (Sub a1 a2) s = evalAExp a1 s - evalAExp a2 s
evalAExp (Mult a1 a2) s = evalAExp a1 s * evalAExp a2 s

evalBExp :: BExp -> State -> Bool
evalBExp (BoolLit b) _ = b
evalBExp (CompEq a1 a2) s = evalAExp a1 s == evalAExp a2 s
evalBExp (CompLtEq a1 a2) s = evalAExp a1 s <= evalAExp a2 s
evalBExp (Neg b) s = not (evalBExp b s)
evalBExp (And b1 b2) s = evalBExp b1 s && evalBExp b2 s

updateState :: String -> Int -> State -> State
updateState x v s = (x, v):filter (\(y, _) -> x /= y) s

evalStmt :: Stmt -> State -> State
evalStmt (Assign x v) s = updateState x (evalAExp v s) s
evalStmt (Seq xs) s = foldl (flip evalStmt) s xs
evalStmt (IfThenElse b s1 s2) s = if evalBExp b s then evalStmt s1 s else evalStmt s2 s
evalStmt st@(WhileDo b s1) s = if evalBExp b s then evalStmt (Seq [s1,st]) s else s



varX = Var "x"
varN = Var "n"
zero = Num 0
one = Num 1

example1 = Seq [Assign "x" (Num 77), Assign "y" (Mult varX varX)]
example2 = Seq [Assign "x" (Num (-32)), IfThenElse
  (Neg (CompLtEq zero varX)) (Assign "x" (Sub zero varX)) (Seq [])]
example3 = Seq [
  Assign "n" (Num 5), Assign "f" one, WhileDo (CompLtEq one varN)
  (Seq [
    Assign "f" (Mult (Var "f") varN), Assign "n" (Sub varN one)
  ])]

state1 = []
eval1 = evalStmt example1 state1

state2 = []
eval2 = evalStmt example2 state2

state3 = []
eval3 = evalStmt example3 state3