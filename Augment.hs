{-# LANGUAGE MultiParamTypeClasses, TypeFamilies,
  FlexibleInstances, UndecidableInstances, OverlappingInstances #-}

module Augment (augment) where

class Augment a b f h where
   augment :: (a -> b) -> f -> h

instance (a ~ c, h ~ b) => Augment a b c h where
   augment = ($)

instance (Augment a b d h', h ~ (c -> h')) => Augment a b (c -> d) h where
   augment g f = augment g . f

--{-# LANGUAGE TypeFamilies, DefaultSignatures, FlexibleInstances, NoMonomorphismRestriction #-}
--module Augment (augment) where

--class Augment a where
--  type Result a
--  type Result a = a

--  type Augmented a r
--  type Augmented a r = r

--  augment' :: (Result a -> r) -> a -> Augmented a r

--  default augment' :: (a -> r) -> a -> r
--  augment' g x = g x

--instance Augment b => Augment (a -> b) where
--  type Result (a -> b) = Result b
--  type Augmented (a -> b) r = a -> Augmented b r

--  augment' g f x = augment' g (f x)

--augment = flip augment'

----instance Augment a
----instance Augment Bool
----instance Augment (IO a)
--instance Augment (m a)
--instance Augment Char
----instance Augment String
----instance Augment Handle
--instance Augment Integer
--instance Augment [a]
