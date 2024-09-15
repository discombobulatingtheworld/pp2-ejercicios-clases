module Main where

import Data.List (intercalate)
import System.IO (getLine)
import System.Environment (getArgs)
import Syntax.Lexer (alexScanTokens)
import Syntax.Parser (parse)
import Semantics.Interpreter (evalStmt, State)

getLines :: IO String
getLines = do
  line <- getLine
  if (null line) then return line else do
    rest <- getLines
    return (line ++ '\n':rest)

data ReplMode = OnlyTokens | OnlyAST | Evaluate deriving (Eq, Show)

getReplModeFromArgs :: [String] -> ReplMode
getReplModeFromArgs ("-t":_) = OnlyTokens
getReplModeFromArgs ("-a":_) = OnlyAST
getReplModeFromArgs [] = Evaluate
getReplModeFromArgs args = error ("Unrecognized args "++ (intercalate " " args))

repl :: ReplMode -> State -> IO ()
repl m s = do
  code <- getLines
  let tokens = alexScanTokens code
  if (m == OnlyTokens) then do
    print tokens
    repl m s
  else do
    let ast = parse tokens
    if (m == OnlyAST) then do
      print ast
      repl m s
    else do
      let s2 = evalStmt ast s
      putStrLn ("// "++ intercalate ", " [var ++"="++ (show val) | (var, val) <- s2] ++".")
      repl m s2

main :: IO ()
main = do
  args <- getArgs
  repl (getReplModeFromArgs args) []