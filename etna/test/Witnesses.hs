module Main where

import Etna.Result (PropertyResult(..))
import Etna.Witnesses
  ( witness_path_segments_round_trip_case_three
  , witness_path_segments_round_trip_case_single
  , witness_path_segments_round_trip_case_two
  )
import System.Exit (exitFailure, exitSuccess)

cases :: [(String, PropertyResult)]
cases =
  [ ("witness_path_segments_round_trip_case_three",  witness_path_segments_round_trip_case_three)
  , ("witness_path_segments_round_trip_case_single", witness_path_segments_round_trip_case_single)
  , ("witness_path_segments_round_trip_case_two",    witness_path_segments_round_trip_case_two)
  ]

main :: IO ()
main = do
  let failures =
        [ (n, msg) | (n, Fail msg) <- cases ] ++
        [ (n, "discard") | (n, Discard) <- cases ]
  if null failures
    then do
      putStrLn $ "OK: all " ++ show (length cases) ++ " witnesses passed"
      exitSuccess
    else do
      mapM_ (\(n, m) -> putStrLn (n ++ ": FAIL: " ++ m)) failures
      exitFailure
