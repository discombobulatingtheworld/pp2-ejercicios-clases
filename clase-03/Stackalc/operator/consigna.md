# Ejercicio 2.4: operator

Definir la función `operator`, que retorna funciones dado un `Char`.

Todas las funciones toman una lista de `Double` y retornan una lista de `Double`.

- Los dígitos `0123456789` agregan el valor a la lista.
- `operator '7' = (\ns → 7.0:ns)`
- Los símbolos `+-*/` toman dos valores y ponen el resultado.
- `operator '+' = (\(n1:n2:ns) -> (n1 + n2):ns)`
- En cualquier otro caso se debe arrojar un error.

# Soluciones

- [Opción A](operator_a.hs)

## Opción A

```powershell
PS PATH\operator> ghci .\operator_a.hs
GHCi, version 9.4.8: https://www.haskell.org/ghc/  :? for help
[1 of 2] Compiling Main             ( operator_a.hs, interpreted )
Ok, one module loaded.
ghci> (operator '1') []
[1.0]
ghci> (operator '2') [1.0]
[2.0,1.0]
ghci> (operator '9') [1.0,5.0,7.6]
[9.0,1.0,5.0,7.6]
ghci> (operator '+') [3.0,5.0]    
[8.0]
ghci> (operator '-') [4.0,5.0,3.0]
[-1.0,3.0]
```