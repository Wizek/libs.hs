{-# LANGUAGE QuasiQuotes #-}

import Test.Hspec
import System.IO
import System.Process
import Data.Default
import System.Timeout
import Augment
-- import Data.String.QQ
-- import Data.String.Here.Interpolated
import Data.String.Here
import Test.HUnit as HUnit


main :: IO ()
main = hspec $ do
  describe "Prelude.head" $ do
    it "asd" $ do
      state <- given_the_application_starts
      then_the_initial_state_should_be_displayed state

then_the_initial_state_should_be_displayed (inp,out,err,pid) = do
  assertHContains out output 40
  where output = [hereFile|Debug/e2eOutput.txt|]
given_the_application_starts = do
  a@(inp,out,err,pid) <- runInteractiveProcess "bash" ["-c","runghc Debug/e2eInput.hs 2>&1"] def def
  hSetBinaryMode out False
  --hSetNewlineMode inp noNewlineTranslation
  hSetBuffering inp NoBuffering
  hSetBuffering out NoBuffering
  return a


longerThan [] []          = False
longerThan _  []          = True
longerThan [] _           = False
longerThan (_:xs) (_:ys)  = longerThan xs ys

assertHContains :: Handle -> String -> Int -> HUnit.Assertion
assertHContains = augment fn hContains
  where
    --fn :: IO Bool -> HUnit.Assertion
    --fn bool = fmap (assertBool "Oh, noes!") bool
    fn bool = do
      b <- bool
      case b of
        Right _ -> assertBool "Oh, noes!" True
        Left reason -> assertBool reason False


hContains = hContainsFactory hGetChar assertBool stringContains
hContainsFactory hGetChar assertBool stringContains = hContains'
  where
  --hContains' :: Handle -> String -> Int -> IO Bool
  hContains' :: Handle -> String -> Int -> IO (Either String Bool)
  hContains' h str fullttl = fn "" fullttl
    where
    --fn :: Int
    fn acc ttl = do
      --undefined :: Int
      --print ("hContains", length acc, drop (length acc - 5) acc)
      case stringContains acc str of
        True  ->
          --assertBool "Match!" True
          return $ Right True
        False -> case (ttl > 0) of
          --True  -> return False
          True  -> do
            l <- timeout 1000000 $ hGetChar h
            case l of
              Just c ->
                fn (acc ++ [c]) (ttl - 1)
              _ -> error $ "hola " ++ acc
            --xxx
            --return xxx
          False ->
            --error "helloo"
            --assertBool reason False
            return $ Left reason
      where reason = unlines ["No match of", show str, "in (" ++ show fullttl ++ ")", show acc]


stringContains a b = stringContains' a b

stringContains' _ "" = True
stringContains' "" _ = False
stringContains' a b
  | b `longerThan` a          = False
  | all id (zipWith (==) a b) = True
  | otherwise                 = stringContains' (tail a) b
