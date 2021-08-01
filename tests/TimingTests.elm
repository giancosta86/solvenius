module TimingTests exposing (..)

import Expect
import Test exposing (..)
import Timing exposing (formatMillis)


suite : Test
suite =
    describe "formatMillis should handle"
        [ describe
            "when less than 1 minute"
            [ test "when zero" <|
                \_ -> formatMillis 0 |> Expect.equal (Ok "0s")
            , test "precise number of seconds" <|
                \_ -> formatMillis 1000 |> Expect.equal (Ok "1s")
            , test "slightly more than one second" <|
                \_ -> formatMillis 1020 |> Expect.equal (Ok "1s")
            , test "almost 2 seconds" <|
                \_ -> formatMillis 1999 |> Expect.equal (Ok "1s")
            ]
        , test "1 minute" <|
            \_ -> formatMillis 60000 |> Expect.equal (Ok "1m 0s")
        , describe
            "when more than 1 minute"
            [ test "64s" <|
                \_ -> formatMillis 64000 |> Expect.equal (Ok "1m 4s")
            , test "119s" <|
                \_ -> formatMillis 119000 |> Expect.equal (Ok "1m 59s")
            , test "2m" <|
                \_ -> formatMillis 120000 |> Expect.equal (Ok "2m 0s")
            ]
        ]
