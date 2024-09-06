# Stackalc.hs - Ej. 2.4 y 2.5

Se desea implementar una calculadora de pila simple en Haskell.

- El código será un `String`, donde cada carácter es un operador.
- Las operaciones se aplicarán sobre una pila de `Double`.

Por ejemplo:

- `evaluate “123*+” = [7.0]`
- `evaluate “012/-” = [-0.5]`

## Ejercicios

- [Ejercicio 2.4: operator](operator/consigna.md)
- [Ejercicio 2.5: evaluate](evaluate/consigna.md)

---

# Soluciones

- [Opcion A](./Stackalc_a.hs)

## Opcion A

```powershell
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

```powershell
ghci> evaluate ""
[]
ghci> evaluate "123"
[3.0,2.0,1.0]
ghci> evaluate "123*+"
[7.0]
ghci> evaluate "21/0-"
[-0.5]
ghci> evaluate "12+3+4"
[4.0,6.0]
ghci> evaluate "1+"
*** Exception: Sin suficientes elementos
CallStack (from HasCallStack):
  error, called at Stackalc_a.hs:5:63 in main:Main
ghci> evaluate "23!"
*** Exception: Operador no soportado!
CallStack (from HasCallStack):
  error, called at Stackalc_a.hs:16:19 in main:Main
  ```