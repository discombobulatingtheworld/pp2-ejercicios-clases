# Ejercicio 2.5: evaluate

Definir la función `evaluate`, que toma un `String` con una fórmula en notación posfija (polaca inversa).

Retorna su evaluación usando la función `operator` anterior.

- `evaluate "" = []`
- `evaluate "123" = [3.0, 2.0, 1.0]`
- `evaluate "123*+" = [7.0]`
- `evaluate "21/0" = [-0.5]`
- `evaluate "12+3+4" = [4.0, 6.0]`
- `evaluate "1+" = error`
- `evaluate "23!" = error`

¿Se podrá usar una función de alto orden estándar?

# Soluciones

