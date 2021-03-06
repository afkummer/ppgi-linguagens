module Lam where

--Tipos
data Type = TypeBool
			 | TypeNat
          | TypeFunc Type Type
          | TypeUnit
          | TypeErr String 
          | TypeTuple (Type, Type) 
          | TypeRecord [(Char, Type)] deriving (Show,Eq,Ord) 

--data = operador que possibilida o usuário construir tipos novos
--TLam significa Termos Lambda - aqui está se definindo uma árvore de sintaxe abstrata
data TLam = Var Char 
          | Abs Char Type TLam
          | App TLam TLam 
          | TTrue
          | TFalse
          | TIf TLam TLam TLam
          | TZero
          | TSucc TLam
          | TPred TLam
          | TIsZero TLam 
          | TUnit 
          | TSeq TLam TLam
          | TLet Char TLam TLam 
          | TTuple (TLam, TLam)
          | TProjTuple TLam Int 
          | TRecord [(Char, TLam)]
          | TProjRecord TLam Char  deriving (Show)
          
{-Em função dos tipos não funciona mais

--Função que indica as variáveis livres de uma sintaxe abstrata Lambda
freeVariables :: TLam -> [Char]
freeVariables (Var x) = [x]
freeVariables (Abs x t) = remo x (freeVariables t)
freeVariables (App t1 t2) = freeVariables(t1) ++ freeVariables(t2)

--Funções que removem as variáveis livres
remove :: Char -> [Char] -> [Char]
remove x [] = []
remove x (a:b) = if (x == a) then b else a:(remove x b)

--remove implementada com list comprehensions
remo x l = [y | y <- l, y /= x]

--Função que aplica a beta redução (substituição) a uma sintaxe abstrata Lambda
--Parâmetro 1 - Char - Caracter (variável livre do corpo) que irá ser substituído na expressão Lambda do Parâmetro 3
--Parâmetro 2 - TLam - Lambda que irá substituir o Parâmetro 1 na expressão Lambda do Parâmetro 3
--Parâmetro 3 - TLam - Lambda onde será aplicada a substituição
subs :: Char -> TLam -> TLam -> TLam
subs x s (Var y) = if (x == y) then s else (Var y)
subs x s (Abs y t1) = if (x == y) then (Abs y t1) --Evita liberar variáveis (retorna a própria exrpressão)
                      else if ( (x /= y) && not(elem y (freeVariables s)) ) then (Abs y (subs x s t1))
                      else error "erro na substituição da Abstração" --Aqui teria que ter um tratamento para não capturar variáveis
subs x s (App t1 t2) = App (subs x s t1) (subs x s t2) 

--Função que retorna se uma expressão é um valor
--Valor: uma variável ou uma abstração
isVal :: TLam -> Bool
isVal (Var x) = True
isVal (Abs x t1) = True
isVal n = False -- Caso não for uma variaval ou abstração, retorna false

--Função que avalia uma expressão Lambda através do método Call By Value (chamada por valor) - Apenas um passo de avaliação
evalCBV :: TLam -> TLam
evalCBV (Var x) = (Var x) --Se for uma variável, apenas retorna-a
evalCBV (Abs x t1) = (Abs x t1) --Se for uma abstração, apenas retorna-a
evalCBV (App (Abs x t12) v2) = if (isVal v2) --EAPPABS
                               then (subs x v2 t12)
                               else let t2 = evalCBV v2 --Caso o v2 não seja um valor (ou seja, seja uma Aplicação) 
                                    in (App (Abs x t12) t2) 
evalCBV (App t1 t2) = if (not (isVal t1))
                      then let t1' = (evalCBV t1) --EAPP1
                           in (App t1' t2)           
                      else let t2' = (evalCBV t2) --EAPP2 (essa é igual ao EAPPABS, porém caso o t1 seja um Var (e não um Abs), talvez não funcione
                           in (App t1 t2')
                           
                           
-}                           
