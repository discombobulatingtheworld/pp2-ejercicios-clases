module Semantics.Compiler where

import Data.List ( nub, elemIndex )
import Semantics.EnvelopeTemp ( addEnvelope )
import Syntax.CodeRepr ( AExp(Num, Var, Add, Mult, Sub, Div), BExp(BoolLit, CompEq, CompLtEq, CompGtEq, Neg, And, Or), Stmt(Assign, Seq, IfThenElse, WhileDo) )
import Distribution.Simple (Compiler(Compiler))

ilLocals :: Stmt -> [String]
ilLocals (Assign x _) = [x]
ilLocals (Seq stmts) = nub (concatMap ilLocals stmts)
ilLocals (IfThenElse b s1 s2) = nub (concatMap ilLocals [s1, s2])
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
ilMaxStackAExp (Div a1 a2) =
  max (ilMaxStackAExp a1) (1 + ilMaxStackAExp a2)

ilMaxStackBExp :: BExp -> Int
ilMaxStackBExp (BoolLit _) = 1
ilMaxStackBExp (CompEq a1 a2) =
  max (ilMaxStackAExp a1) (1 + ilMaxStackAExp a2)
ilMaxStackBExp (CompLtEq a1 a2) =
  max (ilMaxStackAExp a1) (1 + ilMaxStackAExp a2)
ilMaxStackBExp (CompGtEq a1 a2) =
  max (ilMaxStackAExp a1) (1 + ilMaxStackAExp a2)
ilMaxStackBExp (Neg b1) = ilMaxStackBExp b1
ilMaxStackBExp (And b1 b2) =
  max (ilMaxStackBExp b1) (1 + ilMaxStackBExp b2)
ilMaxStackBExp (Or b1 b2) =
  max (ilMaxStackBExp b1) (1 + ilMaxStackBExp b2)

ilMaxStackStmt :: Stmt -> Int
ilMaxStackStmt (Assign x a) = ilMaxStackAExp a
ilMaxStackStmt (Seq stmts) =
  maximum (0 : map ilMaxStackStmt stmts)
ilMaxStackStmt (IfThenElse b s1 s2) =
  maximum [ilMaxStackBExp b, ilMaxStackStmt s1, ilMaxStackStmt s2]
ilMaxStackStmt (WhileDo b s) =
  max (ilMaxStackBExp b) (ilMaxStackStmt s)

data CodeGenContext = CodeGenContext {
  locals :: [String],
  nextTag :: Int
} deriving (Show)

ilCompileAExp :: AExp -> CodeGenContext -> [String]
ilCompileAExp (Num n) _ = ["ldc.i4 "++ show n]
ilCompileAExp (Var x) ctx = ["ldloc.s "++ show i]
  where (Just i) = elemIndex x (locals ctx)
ilCompileAExp (Add a1 a2) ctx =
  concat [ilCompileAExp a1 ctx, ilCompileAExp a2 ctx, ["add"]]
ilCompileAExp (Sub a1 a2) ctx =
  concat [ilCompileAExp a1 ctx, ilCompileAExp a2 ctx, ["sub"]]
ilCompileAExp (Mult a1 a2) ctx =
  concat [ilCompileAExp a1 ctx, ilCompileAExp a2 ctx, ["mul"]]
ilCompileAExp (Div a1 a2) ctx =
  concat [ilCompileAExp a1 ctx, ilCompileAExp a2 ctx, ["div"]]

ilCompileBExp :: BExp -> CodeGenContext -> [String]
ilCompileBExp (BoolLit bool) _
  | bool = ["ldc.i4.1"]
  | otherwise = ["ldc.i4.0"]
ilCompileBExp (CompEq a1 a2) ctx =
  concat [ilCompileAExp a1 ctx, ilCompileAExp a2 ctx, ["ceq"]]
ilCompileBExp (CompLtEq a1 a2) ctx =
  concat [ilCompileAExp a2 ctx, ilCompileAExp a1 ctx, ["cgt"]]
ilCompileBExp (CompGtEq a1 a2) ctx =
  concat [ilCompileAExp a2 ctx, ilCompileAExp a1 ctx, ["clt"]]
ilCompileBExp (Neg b1) ctx =
  concat [ilCompileBExp b1 ctx, ["ldc.i4.0"], ["ceq"]]
ilCompileBExp (And b1 b2) ctx =
  concat [ilCompileBExp b1 ctx, ilCompileBExp b2 ctx, ["and"]]
ilCompileBExp (Or b1 b2) ctx =
  concat [ilCompileBExp b1 ctx, ilCompileBExp b2 ctx, ["or"]]

ilCompileStmt :: Stmt -> [String]
ilCompileStmt s = [ ".maxstack " ++ show maxStack ] ++
  [ ".locals init (" ++ prog ++ ")" ] ++
  fst (_ilCompileStmt s ctx)
    where prog = drop 2 (concat [ ", int32 V_" ++ show idx | idx <- [0..(length locals - 1)] ])
          ctx = CodeGenContext{ locals = locals, nextTag = 0 }
          maxStack = ilMaxStackStmt s
          locals = ilLocals s

_ilCompileStmt :: Stmt -> CodeGenContext -> ([String], CodeGenContext)
_ilCompileStmt (Assign x a1) ctx =
  (ilCompileAExp a1 ctx ++ ["stloc.s " ++ show i], ctx)
    where (Just i) = elemIndex x (locals ctx)
_ilCompileStmt (Seq xs) ctx
  | null xs = ([], ctx)
  | length xs == 1 = _ilCompileStmt (head xs) ctx
  | otherwise =
      (s1 ++ s2, ctx2)
        where (s2, ctx2) = _ilCompileStmt (Seq (tail xs)) ctx1
              (s1, ctx1) = _ilCompileStmt (head xs) ctx
_ilCompileStmt (IfThenElse b1 s1 s2) ctx =
  (concat [
    ilCompileBExp b1 newCtx,
    ["ldc.i4.1"],
    ["ceq"],
    ["brtrue " ++ t1],
    s2a,
    ["br " ++ t2 ],
    (\(x1:xt) -> (t1 ++ ": " ++ x1):xt) s1a,
    [t2 ++ ": nop"]
  ], newCtx)
    where newCtx = CodeGenContext{ locals = locals ctx2, nextTag = i1 + 2 }
          t2 = "T" ++ show (i1 + 1)
          t1 = "T" ++ show i1
          i1 = nextTag ctx2
          (s2a, ctx2) = _ilCompileStmt s2 ctx1
          (s1a, ctx1) = _ilCompileStmt s1 ctx
_ilCompileStmt (WhileDo b1 s1) ctx =
  (concat [
    [t1 ++ ": nop"],
    ilCompileBExp b1 newCtx,
    ["ldc.i4.1"],
    ["ceq"],
    ["brfalse " ++ t2],
    s1a,
    ["br " ++ t1],
    [t2 ++ ": nop"]
  ], newCtx)
    where newCtx = CodeGenContext{ locals = locals ctx1, nextTag = i1 + 2 }
          t2 = "T" ++ show (i1 + 1)
          t1 = "T" ++ show i1
          i1 = nextTag ctx1
          (s1a, ctx1) = _ilCompileStmt s1 ctx

ilCompileProgram :: Stmt -> String -> String
ilCompileProgram s n =
  addEnvelope n (concatMap (\s -> "    " ++ s ++ "\n") (ilStmts ++ ["ret"]))
    where ilStmts = ilCompileStmt s