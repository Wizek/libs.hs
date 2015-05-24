{-# LANGUAGE FlexibleInstances #-}
-- Variable argument length experiment

import Data.Either

data OneOrTwo = One (Int -> Int) | Two (Int -> Int -> Int)

instance Show (Int -> Int) where show _ = "asd"

varArgs 1 = One (\x -> x)
varArgs 2 = Two (\x y -> x + y)


fn 1 = Left "a"
fn 2 = Right "b"

main = do
  print $ case fn 1 of Left x -> x
  print $ case fn 1 of Right x -> x
  -- print $ case varArgs 1 of Two fn -> fn 3
  -- print $ let One fn = varArgs 1 in fn 3
  -- print $ let Two fn = varArgs 2 in fn 3 4
  -- print $ let One fn = varArgs 2 in fn 3 4  -- shouldn't execute
  -- print $ let Two fn = varArgs 1 in fn 3  -- shouldn't execute
