module Semantics.Interpreter where

import Syntax.CodeRepr (AExp(Num, Var, Add, Sub, Mult, Div), BExp(BoolLit, CompEq, CompGt, CompLt, CompLtEq, CompGtEq, Neg, And, Or), Stmt(Assign, Seq, IfThenElse, WhileDo))

-- data AExp = Num Int | Var String
--           | Add AExp AExp | Sub AExp AExp
--           | Mult AExp AExp | Div AExp AExp deriving (Eq, Show)
-- data BExp = BoolLit Bool 
--           | CompEq AExp AExp | CompLtEq AExp AExp | CompGtEq AExp AExp
--           | Neg BExp | And BExp BExp | Or BExp BExp deriving (Eq, Show)
-- data Stmt = Assign String AExp
--           | Seq [Stmt]
--           | IfThenElse BExp Stmt Stmt
--           | WhileDo BExp Stmt deriving (Eq, Show)
-- skip = Seq []

type State = [(String, Int)]

evalAExp :: AExp -> State -> Int
evalAExp (Num n) _ = n
evalAExp (Var x) s = let (Just v) = (lookup x s) in v
evalAExp (Add a1 a2) s = (evalAExp a1 s) + (evalAExp a2 s)
evalAExp (Sub a1 a2) s = (evalAExp a1 s) - (evalAExp a2 s)
evalAExp (Mult a1 a2) s = (evalAExp a1 s) * (evalAExp a2 s)
evalAExp (Div a1 a2) s = div (evalAExp a1 s) (evalAExp a2 s)

updateState :: String -> Int -> State -> State
updateState x v s = (x, v):(filter (\(y, _) -> x /= y) s)

evalBExp :: BExp -> State -> Bool
evalBExp (BoolLit b) _ = b
evalBExp (CompEq a1 a2) s = (evalAExp a1 s) == (evalAExp a2 s)
evalBExp (CompLt a1 a2) s = (evalAExp a1 s) < (evalAExp a2 s)
evalBExp (CompGt a1 a2) s = (evalAExp a1 s) > (evalAExp a2 s)
evalBExp (CompLtEq a1 a2) s = (evalAExp a1 s) <= (evalAExp a2 s)
evalBExp (CompGtEq a1 a2) s = (evalAExp a1 s) >= (evalAExp a2 s)
evalBExp (Neg b1) s = not (evalBExp b1 s)
evalBExp (And b1 b2) s = (evalBExp b1 s) && (evalBExp b2 s)
evalBExp (Or b1 b2) s = (evalBExp b1 s) || (evalBExp b2 s)

evalStmt :: Stmt -> State -> State
evalStmt (Assign x a) s = (x, v):(filter (\(y, _) -> x /= y) s)
  where v = evalAExp a s
evalStmt (Seq stmts) s = foldl (\s stmt -> evalStmt stmt s) s stmts
evalStmt (IfThenElse b s1 s2) s = evalStmt (
  if (evalBExp b s) then s1 else s2) s
evalStmt (WhileDo b s1) s = if (evalBExp b s) then (
  evalStmt (WhileDo b s1) (evalStmt s1 s)) else s
