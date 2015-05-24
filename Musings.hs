-- This pragma + instance declaration is only to prevent an unrelated error
-- "No instance for (Show (Int -> Int)) arising from a use of ‘print’"
{-# LANGUAGE FlexibleInstances #-}
instance Show (Int -> Int) where show _ = "->"
-- Below is the relevant code:

-- Variable argument length experiment

data OneOrTwo = One (Int -> Int) | Two (Int -> Int -> Int)

varArgs 1 = One (\x -> x)
varArgs 2 = Two (\x y -> x + y)

main = do
  print $ let One fn = varArgs 1 in fn 3
  print $ let Two fn = varArgs 2 in fn 3 4
  -- print $ let One fn = varArgs 2 in fn 3 4  -- shouldn't execute
  print $ let Two fn = varArgs 1 in fn 3  -- shouldn't execute

