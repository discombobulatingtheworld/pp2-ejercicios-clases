# Ejercicio 2.2: isSorted

Implementar la función `isSorted` que verifica si los elementos de una lista están ordenados (de manera ascendente).

- Al menos una solución debe usar funciones de alto orden.

Por ejemplo:

- `isSorted “abcd” = True`
- `isSorted “dcba” = False`
- `isSorted [1,2,3] = False`
- `isSorted “xxx” = True`
- `isSorted [1.2] = True`
- `isSorted [] = True`

# Soluciones

- [Opción A](isSorted_a.hs)

## Opción A

```haskell
isSorted :: (Ord a) => [a] -> Bool
isSorted xs = all (== True) (zipWith (<=) xs (tail xs))
```

### Verificación

```powershell
PS PATH> ghci .\isSorted_a.hs                                                  
GHCi, version 9.4.8: https://www.haskell.org/ghc/  :? for help
[1 of 2] Compiling Main             ( isSorted_a.hs, interpreted )
Ok, one module loaded.
ghci> isSorted "abcd" 
True
ghci> isSorted "dcba"
False
ghci> isSorted [1,2,3]
True
ghci> isSorted "xxx"  
True
ghci> isSorted [1.2]
True
ghci> isSorted []   
True
```