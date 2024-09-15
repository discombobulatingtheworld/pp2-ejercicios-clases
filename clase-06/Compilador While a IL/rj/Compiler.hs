import Data.List (nub)
import Syntax.CodeRepr
import Semantics.Interpreter
import Data.List (elemIndex)

ilLocals :: Stmt -> [String]
ilLocals (Assign x _) = [x]
ilLocals (Seq stmts) = nub (concat (map ilLocals stmts))
ilLocals (IfThenElse b s1 s2) = nub (concat (map ilLocals [s1, s2]))
ilLocals (WhileDo b s) = ilLocals s

ilMaxStackAExp :: AExp -> Int
ilMaxStackAExp (Num _) = 1
ilMaxStackAExp (Var _) = 1
ilMaxStackAExp (Add a1 a2) =
  max (ilMaxStackAExp a1) (1 + ilMaxStackAExp a2)
ilMaxStackAExp (Mult a1 a2) =
  max (ilMaxStackAExp a1) (1 + ilMaxStackAExp a2)
ilMaxStackAExp (Sub a1 a2) =
  max (ilMaxStackAExp a1) (1 + ilMaxStackAExp a2)

ilMaxStackBExp :: BExp -> Int
ilMaxStackBExp (BoolLit _) = 1
ilMaxStackBExp (CompEq a1 a2) =
  max (ilMaxStackAExp a1) (1 + ilMaxStackAExp a2)
ilMaxStackBExp (CompLtEq a1 a2) =
  max (ilMaxStackAExp a1) (1 + ilMaxStackAExp a2)
ilMaxStackBExp (Neg b1) = ilMaxStackBExp b1
ilMaxStackBExp (And b1 b2) =
  max (ilMaxStackBExp b1) (1 + ilMaxStackBExp b2)

ilMaxStackStmt :: Stmt -> Int
ilMaxStackStmt (Assign x a) = ilMaxStackAExp a
ilMaxStackStmt (Seq stmts) =
  maximum (map ilMaxStackStmt stmts)
ilMaxStackStmt (IfThenElse b s1 s2) =
  maximum [ilMaxStackBExp b, ilMaxStackStmt s1, ilMaxStackStmt s2]
ilMaxStackStmt (WhileDo b s) =
  maximum [ilMaxStackBExp b, ilMaxStackStmt s]


data CodeGenContext = CodeGenContext {
    locals :: [String]
  } deriving (Show)

ilCompileAExp :: AExp -> CodeGenContext -> [String]
ilCompileAExp (Num n) _ = ["ldc.i4 "++ (show n)]
ilCompileAExp (Var x) ctx = ["ldloc.s "++ (show i)]
  where (Just i) = elemIndex x (locals ctx)
ilCompileAExp (Add a1 a2) ctx = 
  concat [ilCompileAExp a1 ctx, ilCompileAExp a2 ctx, ["add"]]
-- análogo para Sub y Mult