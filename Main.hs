{-# LANGUAGE GADTs #-}

import Data.List

class PType r where
  p' :: (String -> (IO ())) -> [String] -> r

instance (a ~ ()) => PType (IO a) where
  p' f strings = f (concatList $ reverse strings)
    where concatList = intercalate " "

instance (Show a, PType r) => PType (a -> r) where
  p' f strings = \x -> p' f $ (show x : strings)

p :: (Show a, PType r) => a -> r
p = p' putStrLn []

main = do
  p "a"
  p "ab" 1 2 32
