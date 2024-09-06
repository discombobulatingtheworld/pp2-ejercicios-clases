data Angle = Degrees Double | Radians Double deriving (Show)

toDegrees :: Angle -> Angle
toDegrees a@(Degrees theta) = a
toDegrees (Radians theta) = Degrees (180 / pi * theta)

toRadians :: Angle -> Angle
toRadians a@(Radians theta) = a
toRadians (Degrees theta) = Radians (pi / 180 * theta)

asDegrees :: Angle -> Double
asDegrees a = let (Degrees d) = toDegrees a in d

instance Eq Angle where
  a1 == a2 = diff < epsilon
    where
        diff = abs (asDegrees a1 - asDegrees a2)
        epsilon = 1e-15

instance Ord Angle where
    a1 <= a2 = diff >= epsilon
        where
            diff = asDegrees a2 - asDegrees a1
            epsilon = 1e-15

test1 = Radians pi >= Degrees 180
test2 = Degrees (-10.0) <= Degrees (-9.0)
test3 = Degrees (-10.0) > Degrees (-9.0)