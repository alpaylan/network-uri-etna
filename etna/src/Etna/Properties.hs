module Etna.Properties where

import           Data.List   (intercalate)
import           Etna.Result
import           Network.URI (parseURI, pathSegments)

------------------------------------------------------------------------------
-- Variant: segments_drop_trailing_8dcbd7fe_1
-- "make segments not start with /"  (early buggy state of `segments`)
------------------------------------------------------------------------------

-- | A non-empty list of non-empty path segments to be joined with '/'
-- after a leading '/'. The early buggy 'segments' implementation drops
-- the trailing segment when the input does not end in '/', so e.g.
-- @pathSegments \"http://x/a/b/c\" == [\"a\", \"b\"]@ instead of
-- @[\"a\", \"b\", \"c\"]@.
data PathSegmentsArgs = PathSegmentsArgs
  { psSegments :: ![String]
  } deriving (Show, Eq)

property_path_segments_round_trip :: PathSegmentsArgs -> PropertyResult
property_path_segments_round_trip (PathSegmentsArgs segs)
  | null segs                       = Discard
  | any null segs                   = Discard
  | any (not . validSegmentChar) (concat segs) = Discard
  | otherwise =
      let path   = '/' : intercalate "/" segs
          uriStr = "http://example.com" ++ path
      in case parseURI uriStr of
           Nothing -> Fail $ "parseURI failed on " ++ show uriStr
           Just u ->
             let result = pathSegments u
             in if result == segs
                  then Pass
                  else Fail $
                    "pathSegments of " ++ show uriStr ++
                    " = " ++ show result ++
                    "; expected " ++ show segs

-- A conservative whitelist: lowercase letters and digits. Keeps
-- generated paths uncontroversial w.r.t. the URI grammar so the property
-- only exercises the segments-splitting logic.
validSegmentChar :: Char -> Bool
validSegmentChar c =
  (c >= 'a' && c <= 'z') ||
  (c >= '0' && c <= '9')
