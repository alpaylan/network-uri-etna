{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module Etna.Gens.SmallCheck where

import qualified Test.SmallCheck.Series as SC

import Etna.Properties (PathSegmentsArgs(..))

-- Path segments enumerate over small letter alphabets. The buggy
-- segments drops trailing segments, so the bug shows up at depth 2 with
-- input ["a", "b"].
series_path_segments_round_trip :: Monad m => SC.Series m PathSegmentsArgs
series_path_segments_round_trip = do
  nSegs <- SC.generate (\d -> [1 .. min (d + 1) 3])
  segs  <- replicateA nSegs genSegment
  pure (PathSegmentsArgs segs)
  where
    genSegment = do
      len <- SC.generate (\d -> [1 .. min (d + 1) 2])
      replicateA len (SC.generate (\_ -> ['a', 'b']))

    replicateA :: Applicative f => Int -> f a -> f [a]
    replicateA 0 _ = pure []
    replicateA k f = (:) <$> f <*> replicateA (k - 1) f
