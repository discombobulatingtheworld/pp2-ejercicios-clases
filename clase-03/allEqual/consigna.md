# Ejercicio 2.1: allEqual

Definir la función `allEqual`:

- Toma un lista de valores comparables por igual.
- Retorna si todos los valores son iguales.

Por ejemplo:

- `allEqual [1, 1] = True`
- `allEqual [1, 2] = False`
- `allEqual [1 + 2, 3] = True`
- `allEqual [1] = error!`
- `allEqual [] = error!`

# Soluciones

- [Opción A](allEqual_a.hs)
- [Opción B](allEqual_b.hs)

## Opción A

```
PS PATH> ghci .\allEqual_a.hs
GHCi, version 9.4.8: https://www.haskell.org/ghc/  :? for help
[1 of 2] Compiling Main             ( allEqual_a.hs, interpreted )
Ok, one module loaded.
ghci> allEqual [1, 1]
True
ghci> allEqual [1, 2]
False
ghci> allEqual [1 + 2, 3]
True
ghci> allEqual [1]
*** Exception: La lista debe contener 2 o mas elementos.
CallStack (from HasCallStack):
  error, called at allEqual_a.hs:3:25 in main:Main
ghci> allEqual []
*** Exception: La lista debe contener 2 o mas elementos.
CallStack (from HasCallStack):
  error, called at allEqual_a.hs:3:25 in main:Main
```

## Opción B

```
[Running] runghc "...\allEqual_b.hs"
True
False
True
```