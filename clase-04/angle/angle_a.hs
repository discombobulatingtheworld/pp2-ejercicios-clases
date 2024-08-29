data Angle = Degrees Double | Radians Double deriving (Eq, Show)

toDegrees :: Angle -> Angle
toDegrees a@(Degrees theta) = a
toDegrees (Radians theta) = Degrees ((180 / pi) * theta)

toRadians :: Angle -> Angle
toRadians a@(Radians theta) = a
toRadians (Degrees theta) = Radians ((pi / 180) * theta)