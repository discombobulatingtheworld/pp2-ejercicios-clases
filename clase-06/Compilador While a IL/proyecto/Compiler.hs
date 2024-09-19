import Data.List ( nub, elemIndex )
import Interpreter

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
  max (ilMaxStackBExp b) (ilMaxStackStmt s)

data CodeGenContext = CodeGenContext {
  locals :: [String],
  tags :: [Int]
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
  concat [ilCompileAExp a1 ctx, ilCompileAExp a2 ctx, ["mult"]]

ilCompileBExp :: BExp -> CodeGenContext -> [String]
ilCompileBExp (BoolLit bool) _
  | bool = ["ldc.i4.1"]
  | otherwise = ["ldc.i4.0"]
ilCompileBExp (CompEq a1 a2) ctx =
  concat [ilCompileAExp a1 ctx, ilCompileAExp a2 ctx, ["ceq"]]
ilCompileBExp (CompLtEq a1 a2) ctx =
  concat [ilCompileAExp a2 ctx, ilCompileAExp a1 ctx, ["cgt"]]
ilCompileBExp (Neg b1) ctx =
  concat [ilCompileBExp b1 ctx, ["ldc.i4.0"], ["ceq"]]
ilCompileBExp (And b1 b2) ctx =
  concat [ilCompileBExp b1 ctx, ilCompileBExp b2 ctx, ["and"]]

ilCompileStmt :: Stmt -> [String]
ilCompileStmt s = fst (_ilCompileStmt s ctx)
  where ctx = CodeGenContext{ locals = ilLocals s, tags = [0] }

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
    where newCtx = CodeGenContext{ locals = locals ctx2, tags = [i1+1,i1]++tags ctx2 }
          t2 = "T" ++ show (i1 + 1)
          t1 = "T" ++ show i1
          i1 = head (tags ctx2)
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
    where newCtx = CodeGenContext{ locals = locals ctx1, tags = [i1+1,i1]++tags ctx1 }
          t2 = "T" ++ show (i1 + 1)
          t1 = "T" ++ show i1
          i1 = head (tags ctx1)
          (s1a, ctx1) = _ilCompileStmt s1 ctx




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