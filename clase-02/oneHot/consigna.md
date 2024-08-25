# Ejercicio 1.4: oneHot

Definir la función `oneHot`, que toma un largo *n* y un índice *i*.

Retorna una lista de largo *n* con todos sus elementos en $0$, salvo un $1$ en la posición *i* (si existe).

- `oneHot 0 0 = []`
- `oneHot 3 0 = [1, 0, 0]`
- `oneHot 4 2 = [0, 0, 1, 0]`
- `oneHot (-1) 2 = error “!”`
- `oneHot 2 (-1) = [0, 0]`
- `oneHot 5 7 = [0, 0, 0, 0, 0]`

---

# Soluciones

- [Opción A](oneHot_a.hs)

## Opción A

```
ghci> oneHot 0 0
[]
ghci> oneHot 3 0
[1,0,0]
ghci> oneHot 4 2
[0,0,1,0]
ghci> oneHot (-1) 2
*** Exception: Length can't be negative!
CallStack (from HasCallStack):
  error, called at oneHot.hs:3:19 in main:Main
ghci> oneHot 2 (-1)
[0,0]
ghci> oneHot 5 7
[0,0,0,0,0]
```