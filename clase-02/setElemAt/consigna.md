# Ejercicio 1.3: setElemAt

Definir la función setElemAt que toma una lista, un elemento y una posición, y retorna una nueva lista igual a la dada salvo que tiene el valor dado en la posición dada.

- `setElemAt [1,2,3] 77 1 = [1,77,3]`
- `setElemAt “abcdef” ‘x’ 0 = “xbcdef”`
- `setElemAt “abcdef” ‘x’ 2 = “abxdef”`
- `setElemAt “abcdef” ‘x’ 5 = “abcdex”`
- `setElemAt [0,1,2,3] 1 (-1) = [0,-1,2,3]`
- `setElemAt [] True 0 = [True]`
- `setElemAt [] True 1 = error “!”`
- `setElemAt [False,True] False 3 = error “!”`

---

<aside>
💡 Se nota en el ejemplo 7 que se provee una lista vacía y se le agrega el valor `True` en la posición 0 correctamente. 

Otros casos donde se intenta agregar un elemento fuera del largo de la lista especifican índices 2 o mas posiciones después del final y arrojan error.

Se infiere que se acepta añadir un elemento en la posición siguiente a la ultima, pero en posiciones siguientes debe resultar en error.

</aside>

<aside>
🏠 También se nota que en el ejemplo 5 se pasa el elemento 1 para el índice (-1) pero el resultado esperado por el ejercicio es lo opuesto, el de remplazar el índice 1 con el elemento (-1).

Se asume que esto es un error de escritura del ejercicio y que el ejemplo de uso real es:

`setElemAt [0,1,2,3] (-1) 1 = [0,-1,2,3]`

</aside>

---

# Soluciones

## Opción A

```haskell
setElemAt :: [a] -> a -> Int -> [a]
setElemAt original member index
    | (index < 0) = error "Negative index not supported."
    | ((length original) < index) = error "Index beyond length of list."
    | ((length original) == index) = original++[member]
    | (((length original) > index) && (index >= 0)) = [(if (current == index) then member else original !! current) | current <- [0..((length original) - 1)] ]
```

### Verificación

```
ghci> setElemAt [1,2,3] 77 1  
[1,77,3]
ghci> setElemAt "abcdef" 'x' 0
"xbcdef"
ghci> setElemAt "abcdef" 'x' 2
"abxdef"
ghci> setElemAt "abcdef" 'x' 5
"abcdex"
ghci> setElemAt [0,1,2,3] (-1) 1
[0,-1,2,3]
ghci> setElemAt [] True 0
[True]
ghci> setElemAt [] True 1
*** Exception: Index beyond length of list.
CallStack (from HasCallStack):
  error, called at setElemAt.hs:4:37 in main:Main
ghci> setElemAt [False,True] False 3
*** Exception: Index beyond length of list.
CallStack (from HasCallStack):
  error, called at setElemAt.hs:4:37 in main:Main
```