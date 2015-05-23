{-# LANGUAGE GADTs #-}

module P where

import Data.List

class PType r where
  p' :: [String] -> r

instance (a ~ ()) => PType (IO a) where
  p' strings = putStrLn (reverse $ concatList strings)
    where concatList = intercalate " "

instance (Show a, PType r) => PType (a -> r) where
  p' strings = \x -> p' $ (show x : strings)

p :: (Show a, PType r) => a -> r
p = p' []
