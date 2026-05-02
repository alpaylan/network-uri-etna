module Etna.Gens.QuickCheck where

import qualified Test.QuickCheck as QC

import Etna.Properties (PathSegmentsArgs(..))

gen_path_segments_round_trip :: QC.Gen PathSegmentsArgs
gen_path_segments_round_trip = do
  nSegs    <- QC.choose (1, 4)
  segs     <- QC.vectorOf nSegs genSegment
  pure (PathSegmentsArgs segs)
  where
    genSegment = do
      len  <- QC.choose (1, 4)
      QC.vectorOf len (QC.elements (['a'..'z'] ++ ['0'..'9']))
