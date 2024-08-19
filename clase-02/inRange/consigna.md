# Ejercicio 1.1: inRange

Definir la función `inRange` que determina si un valor está dentro de un rango dado.

- `inRange 5 7 1 = False`
- `inRange 5 7 6 = True`
- `inRange 5 7 8 = False`
- `inRange 5 7 5 = True`
- `inRange 7 5 6 = False`
- `inRange (-1) 0 2 = False`
- `inRange (-1) 1 0 = True`

---

# Soluciones

## Opción A

```haskell
inRange :: Integer -> Integer -> Integer -> Bool
inRange start end x = start <= x && x <= end
```

### Verificación

```
ghci> inRange 5 7 1
False
ghci> inRange 5 7 6
True
ghci> inRange 5 7 8
False
ghci> inRange 5 7 5
True
ghci> inRange 7 5 6
False
ghci> inRange (-1) 0 2
False
ghci> inRange (-1) 1 0
True
```