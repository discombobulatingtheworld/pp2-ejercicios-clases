module Syntax.CodeRepr where

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

skip :: Stmt
skip = Seq []