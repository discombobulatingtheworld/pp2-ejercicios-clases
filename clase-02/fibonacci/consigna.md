# Ejercicio 1.2: fibonacci

Definir la función `fibonacci` , que dado un número natural n retorna el enésimo número en la secuencia de Fibonacci.

- `fibonacci 0 = 0`
- `fibonacci 1 = 1`
- `fibonacci 2 = 1`
- `fibonacci 3 = 2`
- `fibonacci 5 = 5`
- `fibonacci 7 = 13`
- `fibonacci 10 = 55`
- `fibonacci (-1) = error!`

# Soluciones

- [Opción A](fibonacci_a.hs)

## Opción A

```
ghci> fibonacci 0
0
ghci> fibonacci 1
1
ghci> fibonacci 2
1
ghci> fibonacci 3
2
ghci> fibonacci 5
5
ghci> fibonacci 7
13
ghci> fibonacci 10
55
ghci> fibonacci (-1)
*** Exception: Numero negativo!
CallStack (from HasCallStack):
  error, called at fibonacci.hs:3:17 in main:Main
```