{
module Syntax.Lexer where
}

%wrapper "basic"

tokens :-

  $white+                 ;
  "//".*                  ;
  if                      { \s -> TokenIf }
  else                    { \s -> TokenElse }
  while                   { \s -> TokenWhile }
  false                   { \s -> TokenBool False }
  true                    { \s -> TokenBool True }
  !                       { \s -> TokenNot }
  "("                     { \s -> TokenOParen }
  ")"                     { \s -> TokenCParen }
  "*"                     { \s -> TokenMult }
  "/"                     { \s -> TokenDiv }
  "+"                     { \s -> TokenAdd }
  "-"                     { \s -> TokenSub }
  "=="                    { \s -> TokenEq }
  "<"                     { \s -> TokenLt }
  ">"                     { \s -> TokenGt }
  "<="                    { \s -> TokenLtEq }
  ">="                    { \s -> TokenGtEq }
  "&&"                    { \s -> TokenAnd }
  "||"                    { \s -> TokenOr }
  "="                     { \s -> TokenAssign }
  ";"                     { \s -> TokenSemi }
  "{"                     { \s -> TokenOBrace }
  "}"                     { \s -> TokenCBrace }
  [0-9]+                  { \s -> TokenNum (read s) }
  [a-zA-Z][a-zA-Z0-9\_]*  { \s -> TokenId s }

{
data Token 
  = TokenNum Int | TokenBool Bool | TokenId String
  | TokenNot
  | TokenOParen | TokenCParen
  | TokenMult | TokenDiv | TokenAdd | TokenSub
  | TokenEq | TokenLt | TokenGt
  | TokenLtEq | TokenGtEq
  | TokenAnd | TokenOr
  | TokenAssign | TokenSemi
  | TokenOBrace | TokenCBrace
  | TokenIf | TokenElse | TokenWhile
  deriving (Eq, Show)

}
