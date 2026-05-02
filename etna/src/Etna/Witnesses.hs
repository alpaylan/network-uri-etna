module Etna.Witnesses where

import Etna.Properties
import Etna.Result

-- pathSegments round-trip witnesses

witness_path_segments_round_trip_case_three :: PropertyResult
witness_path_segments_round_trip_case_three =
  property_path_segments_round_trip (PathSegmentsArgs ["foo", "bar", "baz"])

witness_path_segments_round_trip_case_single :: PropertyResult
witness_path_segments_round_trip_case_single =
  property_path_segments_round_trip (PathSegmentsArgs ["a"])

witness_path_segments_round_trip_case_two :: PropertyResult
witness_path_segments_round_trip_case_two =
  property_path_segments_round_trip (PathSegmentsArgs ["x", "y"])
