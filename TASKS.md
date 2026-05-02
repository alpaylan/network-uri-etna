# network-uri — ETNA Tasks

Total tasks: 4

## Task Index

| Task | Variant | Framework | Property | Witness |
|------|---------|-----------|----------|---------|
| 001 | `segments_drop_trailing_8dcbd7fe_1` | quickcheck | `PathSegmentsRoundTrip` | `witness_path_segments_round_trip_case_three` |
| 002 | `segments_drop_trailing_8dcbd7fe_1` | hedgehog | `PathSegmentsRoundTrip` | `witness_path_segments_round_trip_case_three` |
| 003 | `segments_drop_trailing_8dcbd7fe_1` | falsify | `PathSegmentsRoundTrip` | `witness_path_segments_round_trip_case_three` |
| 004 | `segments_drop_trailing_8dcbd7fe_1` | smallcheck | `PathSegmentsRoundTrip` | `witness_path_segments_round_trip_case_three` |

## Witness Catalog

- `witness_path_segments_round_trip_case_three` — pathSegments "http://example.com/foo/bar/baz" must equal ["foo", "bar", "baz"]
- `witness_path_segments_round_trip_case_single` — pathSegments "http://example.com/a" must equal ["a"]
- `witness_path_segments_round_trip_case_two` — pathSegments "http://example.com/x/y" must equal ["x", "y"]
