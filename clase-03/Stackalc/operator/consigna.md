# Ejercicio 2.4: operator

Definir la función `operator`, que retorna funciones dado un `Char`.

Todas las funciones toman una lista de `Double` y retornan una lista de `Double`.

- Los dígitos `0123456789` agregan el valor a la lista.
- `operator '7' = (\ns → 7.0:ns)`
- Los símbolos `+-*/` toman dos valores y ponen el resultado.
- `operator '+' = (\(n1:n2:ns) -> (n1 + n2):ns)`
- En cualquier otro caso se debe arrojar un error.