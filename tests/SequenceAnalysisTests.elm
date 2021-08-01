module SequenceAnalysisTests exposing (..)

import Digit exposing (Digit(..))
import DigitStatus exposing (DigitStatus(..))
import Expect
import Sequence exposing (compareSequences)
import Test exposing (..)


suite : Test
suite =
    describe "compareSequences should handle"
        [ describe "when sequences have different lengths"
            [ test "the situation with an error" <|
                \_ -> compareSequences [ Five ] [ Nine, Eight ] |> Expect.err
            ]
        , describe "when sequences have 1 digit"
            [ test "unused digit" <|
                \_ -> compareSequences [ Five ] [ Seven ] |> Expect.equal (Ok [ Unused ])
            , test "matching digit" <|
                \_ -> compareSequences [ Five ] [ Five ] |> Expect.equal (Ok [ Matching ])
            ]
        , describe "when sequences have 2 digits"
            [ test "both unused digits" <|
                \_ -> compareSequences [ Four, One ] [ Six, Eight ] |> Expect.equal (Ok [ Unused, Unused ])
            , test "Matching + Matching" <|
                \_ -> compareSequences [ Four, One ] [ Four, One ] |> Expect.equal (Ok [ Matching, Matching ])
            , test "Matching + Unused" <|
                \_ -> compareSequences [ Four, One ] [ Four, Seven ] |> Expect.equal (Ok [ Matching, Unused ])
            , test "Unused + Misplaced" <|
                \_ -> compareSequences [ Four, One ] [ Six, Four ] |> Expect.equal (Ok [ Unused, Misplaced ])
            , test "Misplaced + Unused" <|
                \_ -> compareSequences [ Seven, Nine ] [ Nine, Five ] |> Expect.equal (Ok [ Misplaced, Unused ])
            , test "swapped digits" <|
                \_ -> compareSequences [ Four, One ] [ One, Four ] |> Expect.equal (Ok [ Misplaced, Misplaced ])
            , test "Matching + Unused of the same digit" <|
                \_ -> compareSequences [ Five, Seven ] [ Five, Five ] |> Expect.equal (Ok [ Matching, Unused ])
            , test "Misplaced + Matching of the same digit" <|
                \_ -> compareSequences [ Five, Seven ] [ Seven, Seven ] |> Expect.equal (Ok [ Misplaced, Matching ])
            ]
        , describe "when sequences have 3 digits"
            [ test "Unused + Unused + Unused" <|
                \_ -> compareSequences [ Four, One, Three ] [ Nine, Eight, Zero ] |> Expect.equal (Ok [ Unused, Unused, Unused ])
            , test "Matching + Unused + Unused" <|
                \_ -> compareSequences [ Four, One, Three ] [ Four, Eight, Zero ] |> Expect.equal (Ok [ Matching, Unused, Unused ])
            , test "Unused + Matching + Unused" <|
                \_ -> compareSequences [ Four, Eight, Three ] [ Nine, Eight, Zero ] |> Expect.equal (Ok [ Unused, Matching, Unused ])
            , test "Unused + Unused + Matching" <|
                \_ -> compareSequences [ Four, One, Three ] [ Nine, Eight, Three ] |> Expect.equal (Ok [ Unused, Unused, Matching ])
            , test "Matching + Matching + Unused" <|
                \_ -> compareSequences [ Four, One, Three ] [ Four, One, Zero ] |> Expect.equal (Ok [ Matching, Matching, Unused ])
            , test "Matching + Unused + Matching" <|
                \_ -> compareSequences [ Four, One, Zero ] [ Four, Eight, Zero ] |> Expect.equal (Ok [ Matching, Unused, Matching ])
            , test "Unused + Matching + Matching" <|
                \_ -> compareSequences [ Four, One, Three ] [ Nine, One, Three ] |> Expect.equal (Ok [ Unused, Matching, Matching ])
            , test "Matching + Matching + Matching" <|
                \_ -> compareSequences [ Four, One, Three ] [ Four, One, Three ] |> Expect.equal (Ok [ Matching, Matching, Matching ])
            , test "Misplaced + Unused + Unused" <|
                \_ -> compareSequences [ Four, One, Three ] [ Nine, Four, Zero ] |> Expect.equal (Ok [ Unused, Misplaced, Unused ])
            , test "Matching + Misplaced + Unused" <|
                \_ -> compareSequences [ Four, One, Three ] [ Four, Three, Zero ] |> Expect.equal (Ok [ Matching, Misplaced, Unused ])
            , test "Misplaced + Matching + Unused" <|
                \_ -> compareSequences [ Four, One, Three ] [ Three, One, Zero ] |> Expect.equal (Ok [ Misplaced, Matching, Unused ])
            , test "Misplaced + Matching + Unused with twice the same digit" <|
                \_ -> compareSequences [ Four, One, One ] [ One, One, Zero ] |> Expect.equal (Ok [ Misplaced, Matching, Unused ])
            , test "Misplaced + Matching + Misplaced" <|
                \_ -> compareSequences [ Four, One, Three ] [ Three, One, Four ] |> Expect.equal (Ok [ Misplaced, Matching, Misplaced ])
            , test "Misplaced + Matching + Misplaced with twice the same digit" <|
                \_ -> compareSequences [ Four, One, One ] [ One, One, Four ] |> Expect.equal (Ok [ Misplaced, Matching, Misplaced ])
            ]
        ]
