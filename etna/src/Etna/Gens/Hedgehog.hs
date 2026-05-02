module Etna.Gens.Hedgehog where

import           Hedgehog (Gen)
import qualified Hedgehog.Gen   as Gen
import qualified Hedgehog.Range as Range

import Etna.Properties (PathSegmentsArgs(..))

gen_path_segments_round_trip :: Gen PathSegmentsArgs
gen_path_segments_round_trip = do
  segs <- Gen.list (Range.linear 1 4) genSegment
  pure (PathSegmentsArgs segs)
  where
    genSegment =
      Gen.string (Range.linear 1 4)
                 (Gen.element (['a'..'z'] ++ ['0'..'9']))
