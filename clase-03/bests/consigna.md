# Ejercicio 2.3: bests

Definir la función `bests`, que dada una función de evaluación `(a -> Double)` y una lista.

Retorna los elementos con máxima evaluación.

- `bests abs [-7.0..5.0] = [-7.0]`
- `bests fromIntegral [0..10] = [10.0]`
- `bests snd [(’a’,1.0), (’b’, 2.2)] = [(’b’, 2.2)]`
- `bests pmax [(1.0,1.0), (0.0, 3.0)] = [(0.0, 3.0)]`
    - `where pmax (x, y) = max x y`
- `bests pmin [] = []`
    - `where pmin (x, y) = min x y`

Usar funciones de alto orden: `map`, `filter`, `foldr`, etc.

# Soluciones

- [Opción A](bests_a.hs)
- [Opción B](bests_b.hs)

## Opción A

```powershell
PS PATH\bests> ghci .\bests_a.hs
GHCi, version 9.4.8: https://www.haskell.org/ghc/  :? for help
[1 of 2] Compiling Main             ( bests_a.hs, interpreted )
Ok, one module loaded.
ghci> bests abs [-7.0..5.0]
[-7.0]
ghci> bests fromIntegral [0..10]
[10]
ghci> bests snd [('a',1.0), ('b', 2.2)]
[('b',2.2)]
ghci> pmax = (\(x,y) -> max x y)
ghci> bests pmax [(1.0,1.0), (0.0, 3.0)]
[(0.0,3.0)]
ghci> pmin = (\(x,y) -> min x y)
ghci> bests pmin []
[]
```

## Opción B

```powershell
PS PATH\bests> ghci .\bests_b.hs
GHCi, version 9.4.8: https://www.haskell.org/ghc/  :? for help
[1 of 2] Compiling Main             ( bests_b.hs, interpreted )
Ok, one module loaded.
ghci> bests abs [-7.0..5.0]
[-7.0]
ghci> bests fromIntegral [0..10]
[10]
ghci> bests snd [('a',1.0), ('b', 2.2)]
[('b',2.2)]
ghci> pmax = (\(x,y) -> max x y)
ghci> bests pmax [(1.0,1.0), (0.0, 3.0)]
[(0.0,3.0)]
ghci> pmin = (\(x,y) -> min x y)
ghci> bests pmin []
[]
```