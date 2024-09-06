data Angle = Degrees Double | Radians Double deriving (Show)

asDegrees :: Angle -> Double
asDegrees a = let (Degrees d) = toDegrees a in d

instance Eq Angle where
    (==) :: Angle -> Angle -> Bool
    a1 == a2 = diff < epsilon
        where   
            diff = abs ((asDegrees a1) - (asDegrees a2))
            epsilon = 1e-15

instance Ord Angle where
    (>) :: Angle -> Angle -> Bool
    a1 > a2 = compare (asDegrees a1) (asDegrees a2) == GT
    (<) :: Angle -> Angle -> Bool
    a1 < a2 = compare (asDegrees a1) (asDegrees a2) == LT
    (>=) :: Angle -> Angle -> Bool
    a1 >= a2 = compare (asDegrees a1) (asDegrees a2)  == GT || compare (asDegrees a1) (asDegrees a2)  == EQ
    (<=) :: Angle -> Angle -> Bool
    a1 <= a2 = compare (asDegrees a1) (asDegrees a2)  == LT || compare (asDegrees a1) (asDegrees a2)  == EQ

toDegrees :: Angle -> Angle
toRadians :: Angle -> Angle

toDegrees a@(Degrees _) = a
toDegrees (Radians num) = Degrees (num * 180 / pi)

toRadians (Degrees num) = Radians (num / 180 * pi)
toRadians a@(Radians _) = a
