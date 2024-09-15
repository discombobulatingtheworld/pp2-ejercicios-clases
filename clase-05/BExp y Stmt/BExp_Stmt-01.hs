
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

updateState :: String -> Int -> State -> State
updateState x v s = (x,v):(filter (\(y,_)-> x /= y)s)

evalAExp :: AExp -> State -> Int
evalAExp (Num n) _ = n
evalAExp (Var x) s = let (Just v) = (lookup x s) in v
evalAExp (Add a1 a2) s = (evalAExp a1 s) + (evalAExp a2 s)
evalAExp (Sub a1 a2) s = (evalAExp a1 s) - (evalAExp a2 s)
evalAExp (Mult a1 a2) s = (evalAExp a1 s) * (evalAExp a2 s)

evalBExp :: BExp -> State -> Bool
evalBExp (BoolLit bool) _ = bool
evalBExp (CompEq a1 a2) s = (evalAExp a1 s) == (evalAExp a2 s)
evalBExp (CompLtEq a1 a2) s = (evalAExp a1 s) <= (evalAExp a2 s)
evalBExp (Neg bool) s = not (evalBExp bool s)
evalBExp (And b1 b2) s = (evalBExp b1 s) && (evalBExp b2 s)

evalStmt :: Stmt -> State -> State
evalStmt (Assign str a) state = updateState str (evalAExp a state) state
evalStmt (Seq stmts) state = foldl (flip evalStmt) state stmts
evalStmt (IfThenElse bExp stmt1 stmt2) state = if evalBExp bExp state then evalStmt stmt1 state else evalStmt stmt2 state
evalStmt (WhileDo bExp stmt) state
    | not (evalBExp bExp state) = state
    | otherwise = evalStmt (WhileDo bExp stmt) (evalStmt stmt state)
