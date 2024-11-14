# Parcial de Unidad 1 - Programación Funcional

- URL: https://webasignatura.ucu.edu.uy/mod/quiz/view.php?id=723339
- Abrió: jueves, 29 de agosto de 2024, 20:10
- Cerró: jueves, 29 de agosto de 2024, 20:55

## Pregunta 1

Extender la función operator de la implementación de Stackalc hecha en Haskell, para soportar los operadores de potencia (^), negación (~) y la constante (p).

- `evaluate "2~" [] = [-2.0]`
- `evaluate "23^" [] = [8.0]`
- `evaluate "212/^" [] = [1.4142135623730951]`
- `evaluate "p" [] = [3.141592653589793]`

## Pregunta 2

Implementar en Haskell la función numbers que extrae los caractéres numéricos de un String. Por ejemplo:

- `numbers "" = ""`
- `numbers "abcd" = ""`
- `numbers "[3,2,1]" = "321"`
- `numbers "0n3 tw0 thr33" = "03033"`

## Pregunta 3

¿Cuál es la intención de esta función?

```haskell
f :: (Eq a) => [a] -> Bool 
f xs = all (\x -> (filter (x /=) xs) == [x]) xs
```

- a. Determina si no todos los valores de una lista son iguales.
- b. Determina si todos los valores de una lista son diferentes entre sí.
- c. Determina si no todos los valores de una lista son diferentes.
- d. Ninguna de las otras opciones son correctas.

## Respuestas

- [Ejemplo A](entrega_a.md)