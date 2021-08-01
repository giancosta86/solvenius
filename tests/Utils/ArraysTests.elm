module Utils.ArraysTests exposing (..)

import Array
import Utils.Arrays exposing (findIndexFrom)
import Expect
import Test exposing (..)


suite : Test
suite =
    describe "findIndexFrom should"
        [ test "return Nothing when empty array" <|
            \_ -> findIndexFrom "Yogi" Array.empty 0 |> Expect.equal Nothing
        , test "return the only index of array with matching element" <|
            \_ -> findIndexFrom "Yogi" (Array.fromList [ "Yogi" ]) 0 |> Expect.equal (Just 0)
        , test "return Nothing when array with no matching element" <|
            \_ -> findIndexFrom "Yogi" (Array.fromList [ "Bubu" ]) 0 |> Expect.equal Nothing
        , test "return the first index when more matching elements and lower index" <|
            \_ -> findIndexFrom "Yogi" (Array.fromList [ "Dodo", "Yogi", "Bubu", "Yogi" ]) 0 |> Expect.equal (Just 1)
        , test "return the first index when more matching elements and equal index" <|
            \_ -> findIndexFrom "Yogi" (Array.fromList [ "Dodo", "Yogi", "Bubu", "Yogi" ]) 1 |> Expect.equal (Just 1)
        , test "return the following index when more matching elements and index greater than the first" <|
            \_ -> findIndexFrom "Yogi" (Array.fromList [ "Dodo", "Yogi", "Bubu", "Yogi" ]) 2 |> Expect.equal (Just 3)
        ]
