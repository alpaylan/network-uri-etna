# network-uri — Injected Bugs

URI manipulation library (haskell/network-uri). Bug fixes mined from upstream history; modern HEAD is the base, each patch reverse-applies a fix to install the original bug.

Total mutations: 1

## Bug Index

| # | Variant | Name | Location | Injection | Fix Commit |
|---|---------|------|----------|-----------|------------|
| 1 | `segments_drop_trailing_8dcbd7fe_1` | `path_segments_drops_trailing` | `Network/URI.hs:1212` | `patch` | `8dcbd7fec508887c79b07c19bd7b70c7a6876e47` |

## Property Mapping

| Variant | Property | Witness(es) |
|---------|----------|-------------|
| `segments_drop_trailing_8dcbd7fe_1` | `PathSegmentsRoundTrip` | `witness_path_segments_round_trip_case_three`, `witness_path_segments_round_trip_case_single`, `witness_path_segments_round_trip_case_two` |

## Framework Coverage

| Property | quickcheck | hedgehog | falsify | smallcheck |
|----------|---------:|-------:|------:|---------:|
| `PathSegmentsRoundTrip` | ✓ | ✓ | ✓ | ✓ |

## Bug Details

### 1. path_segments_drops_trailing

- **Variant**: `segments_drop_trailing_8dcbd7fe_1`
- **Location**: `Network/URI.hs:1212` (inside `segments`)
- **Property**: `PathSegmentsRoundTrip`
- **Witness(es)**:
  - `witness_path_segments_round_trip_case_three` — pathSegments "http://example.com/foo/bar/baz" must equal ["foo", "bar", "baz"]
  - `witness_path_segments_round_trip_case_single` — pathSegments "http://example.com/a" must equal ["a"]
  - `witness_path_segments_round_trip_case_two` — pathSegments "http://example.com/x/y" must equal ["x", "y"]
- **Source**: internal — make segments not start with /
  > Early buggy state of `segments`: the final case `(_, _) -> Nothing` silently dropped the trailing path segment whenever the input did not end in '/'. So pathSegments of "http://x/foo/bar/baz" returned ["foo", "bar"] instead of ["foo", "bar", "baz"]. The fix introduces an explicit `Just (seg, "")` case for the trailing segment plus a `dropLeadingEmpty` post-pass for absolute paths.
- **Fix commit**: `8dcbd7fec508887c79b07c19bd7b70c7a6876e47` — make segments not start with /
- **Invariant violated**: For an absolute URI path of the form "/<seg1>/<seg2>/.../<segN>" with N >= 1 and every <segi> non-empty, pathSegments returns [<seg1>, <seg2>, ..., <segN>] — every segment present, in order.
- **How the mutation triggers**: Reverse-applying the patch restores the early `segments = unfoldr nextSegmentMaybe` definition where the unfold loop terminates with `Nothing` on the trailing segment (no `/` suffix), silently dropping it. pathSegments of "http://x/foo/bar/baz" then returns ["foo", "bar"]; pathSegments of "http://x/a" returns [].

## Dropped Candidates

- `8c014525f95074a654009802b49fbad63d010402` (Fix ipv4address parser to not depend on broken behaviour of notFollowedBy) — The original bug is in Parsec's pre-2015 `notFollowedBy`: it failed on parsers that succeed with empty consumption (regName matches 0..255 chars). Modern parsec (3.1.x) handles this correctly, so reverse-applying the historical patch restores the workaround but the underlying bug no longer exists — isIPv4address "127.0.0.1" still returns True on the buggy state. Variant is terminally inexpressible against the modern dependency surface.
- `5f16d95a59d7607c0b2d5fc64a3c2c2b24272018` (deal with empty segments correctly) — Subsumed by `segments_drop_trailing_8dcbd7fe_1`. This commit is one step further in the segments-fix chain (8dcbd7fe → 5f16d95 → b6f7062 → 0e1abff2). Reverting only this commit's diff produces a state that still drops trailing segments, just by a different mechanism (`snd $ break (/='/')` over-strips leading slashes). The PathSegmentsRoundTrip property already discriminates this state from HEAD via the same witness inputs.
- `b6f7062ce3883ffac53183437de72123ae85bcdf` (Allow empty segments) — Observationally equivalent to modern HEAD on every input we can express through `pathSegments` (parseURI normalizes the path before segments sees it). The follow-up commit 0e1abff2 was a pure refactor (`dropLeadingEmpty` extracted) with no behavioral delta.
- `0e1abff2b6b50b12a3054d00ebd8a22c3a11af71` (Create tests for pathSegments. Update (simplify?) the implementation a little.) — Pure simplification of `segments` on top of b6f7062 — equivalent observable behavior. Commit message itself flags it as a simplification, and the diff only renames helper bindings.
- `acaad2a568f342e0d9633eed2923125f8e15a24f` (Improve subDelims parser.) — Refactor: replaces `oneOf "!$&'()*+,;="` with `satisfy isSubDelims` against the same character set. No observable behavior change.
- `03b739138390282b85af665adfa56a2b4c3bc588` (Network.URI: improve efficiency of segment parser.) — Performance-only refactor: replaces per-character `pchar` with chunked `pchars` (parses runs of non-escape chars, then concats). Same parse output for every input.
- `21b874a810f234c84f20cdc069517dc22ea69864` (Optimise isReserved) — Performance-only refactor: replaces `c \`elem\` "..."` with explicit `case` over the same character set. No observable behavior change.
