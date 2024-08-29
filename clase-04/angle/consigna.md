# Ejercicio 3.1: Angle

Se define un tipo para representar ángulos medidos en grados, radianes y gadianes.

```haskell
data Angle = Degrees Double | Radians Double deriving (Eq, Show)
```

Definir las funciones de conversión entre unidades, de la siguiente forma:

- `toDegrees (Radians pi) = (Degrees 180.0)`
- `toDegrees (Degrees 12.34) = (Degrees 12.34)`

# Soluciones

- [Opción A](./angle_a.hs)
