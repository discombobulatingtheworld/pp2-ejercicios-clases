isSorted :: (Ord a) => [a] -> Bool
isSorted xs = all (== True) (zipWith (<=) xs (tail xs))