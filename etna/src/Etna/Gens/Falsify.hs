module Etna.Gens.Falsify where

import           Data.List.NonEmpty (NonEmpty(..))
import qualified Test.Falsify.Generator as F
import qualified Test.Falsify.Range     as FR

import Etna.Properties (PathSegmentsArgs(..))

ne :: [a] -> NonEmpty a
ne []     = error "Etna.Gens.Falsify.ne: empty list"
ne (x:xs) = x :| xs

gen_path_segments_round_trip :: F.Gen PathSegmentsArgs
gen_path_segments_round_trip = do
  let segChars = ne (['a'..'z'] ++ ['0'..'9'])
  segs <- F.list (FR.between (1 :: Word, 4))
                 (F.list (FR.between (1 :: Word, 4)) (F.elem segChars))
  pure (PathSegmentsArgs segs)
