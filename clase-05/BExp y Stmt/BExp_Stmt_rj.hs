data AExp = Num Int | Var String
    | Add AExp AExp | Sub AExp AExp
    | Mult AExp AExp deriving (Eq, Show)

data BExp = Val Bool | Equals AExp AExp
    | Leq AExp AExp | Neg BExp
    | And BExp BExp deriving (Eq, Show)

data Stmt = Assignment String AExp | Skip
    | Composite Stmt Stmt | If BExp Stmt Stmt
    | While BExp Stmt deriving (Eq, Show)

-- Ejemplos de BExp
true = Val True
false = Val False
equals = Equals (Num 1) (Num 1)
leq = Leq (Num 3) (Num 10) 
neg = Neg (Val False)
and = And neg true

--- Ejemplos de Stmt
assignment = Assignment "x" (Num 3)
skip = Skip
composite = Composite Skip assignment
ifStmt = If equals composite (Assignment "y" (Num 7))
while = While (Leq (Var "z") (Num 10)) (Composite Skip (Assignment "z" (Add (Num 1) (Var "z"))))

-- Constantes
const1 = Composite (Assignment "x" (Num 77)) (Assignment "y" (Mult (Var "x") (Var "x")))
const2 = Composite (Assignment "x" (Num (-1))) (If (Neg (Leq (Num 0) (Var "x"))) (Assignment "x" (Sub (Num 0) (Var "x"))) Skip)
const3 = Composite (Composite (Assignment "n" (Num 5)) (Assignment "f" (Num 1))) (While (Leq (Num 1) (Var "n")) (Composite (Assignment "f" (Mult (Var "f") (Var "n"))) (Assignment "n" (Sub (Var "n") (Num 1)))))
