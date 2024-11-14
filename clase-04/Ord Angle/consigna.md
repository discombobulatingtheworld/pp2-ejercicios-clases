# Ejercicio 3.3: Eq Angle

Se desea definir la instancia de `Eq` para `Angle`.

- `(Radians pi) == (Degrees 180) = True`
- `(Gradians (-10.0)) == (Degrees (-9.0)) = True`

Se resulta en lo siguiente:

```haskell
asDegrees :: Angle -> Double
asDegrees a = let (Degrees d) = toDegrees a in d

instance Eq Angle where
  a1 == a2 = diff < epsilon
  where diff = abs ((asDegrees a1) - (asDegrees a2))
        epsilon = 1e-15
```

Ahora se busca definir la instancia de Ord para el mismo.

    ℹ️ Investigando se encuentra lo siguiente:

    *Minimal complete definition: either [`compare`](https://hackage.haskell.org/package/base-4.20.0.1/docs/Data-Ord.html#v:compare) or [`<=`](https://hackage.haskell.org/package/base-4.20.0.1/docs/Data-Ord.html#v:-60--61-). Using [`compare`](https://hackage.haskell.org/package/base-4.20.0.1/docs/Data-Ord.html#v:compare) can be more efficient for complex types.*

    https://hackage.haskell.org/package/base-4.20.0.1/docs/Data-Ord.html

# Soluciones

- [Opcion A](./ord_angle_a.hs)

## Opción A

```powershell
ghci> show test1
"True"
ghci> show test2
"True"
ghci> show test3
"False"
```
