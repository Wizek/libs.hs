{-# LANGUAGE GADTs #-}

import Data.List

class PType r where
  asd :: [String] -> r

instance (a ~ ()) => PType (IO a) where
  asd a = putStrLn (reverse $ concatList a)

-- instance (PType r) => PType (Int -> r) where
instance (Show a, PType r) => PType (a -> r) where
  asd a = \x -> asd $ (show x : a)

p :: (Show a, PType r) => a -> r
p = asd []

-- p x = print x
main = do
  p "a"
  p "a" 1
  -- asd 1

  -- asd [] "vv" "sdd" "asdsa"
  -- p 1 2

concatList = intercalate " "


-- class TType a where
--   value :: a

-- instance (a ~ ()) => TType (IO a) where
--   value = putStrLn "IO"

-- instance TType Int where
--   value = 33

-- instance TType Char where
--   value = 'a'

-- -- t = value

-- main = do
--   putStrLn (value : "a")
--   (value :: IO ())
--   -- (t :: IO ())


