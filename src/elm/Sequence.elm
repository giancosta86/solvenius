module Sequence exposing (Sequence, compareSequences)

import Array exposing (Array)
import Dict exposing (Dict)
import Digit exposing (Digit(..))
import DigitStatus exposing (DigitStatus(..))
import Maybe
import Utils.Arrays exposing (findIndexFrom)


type alias Sequence =
    List Digit


type alias LatestOccurrencesDict =
    Dict String Int


type alias Accumulator =
    { latestOccurrences : LatestOccurrencesDict
    , reversedResult : List DigitStatus
    , expectedDigitStrings : Array String
    }


compareSequences : Sequence -> Sequence -> Result String (List DigitStatus)
compareSequences expectedSequence actualSequence =
    let
        initialAccumulator : Accumulator
        initialAccumulator =
            { latestOccurrences = Dict.empty
            , reversedResult = []
            , expectedDigitStrings =
                List.map Digit.toString expectedSequence
                    |> Array.fromList
            }

        finalAccumulator : Accumulator
        finalAccumulator =
            List.indexedMap Tuple.pair actualSequence
                |> List.foldl getPartialResult initialAccumulator
    in
    if List.length actualSequence == List.length expectedSequence then
        finalAccumulator.reversedResult
            |> List.reverse
            |> Ok

    else
        Err "The sequence of expected digits and the sequence of actual digits have different lengths!"


getPartialResult : ( Int, Digit ) -> Accumulator -> Accumulator
getPartialResult ( index, digit ) accumulator =
    let
        digitString =
            Digit.toString digit

        expectedDigitString =
            Array.get index accumulator.expectedDigitStrings
                |> Maybe.withDefault "!!!"
    in
    if digitString == expectedDigitString then
        { accumulator
            | reversedResult = Matching :: accumulator.reversedResult
            , latestOccurrences = Dict.insert digitString index accumulator.latestOccurrences
        }

    else
        let
            latestOccurrence =
                Dict.get digitString accumulator.latestOccurrences
                    |> Maybe.withDefault -1

            searchStartIndex =
                latestOccurrence + 1

            maybeFoundIndex =
                findIndexFrom digitString accumulator.expectedDigitStrings searchStartIndex
        in
        case maybeFoundIndex of
            Just foundIndex ->
                { accumulator
                    | latestOccurrences = Dict.insert digitString foundIndex accumulator.latestOccurrences
                    , reversedResult = Misplaced :: accumulator.reversedResult
                }

            Nothing ->
                { accumulator
                    | reversedResult = Unused :: accumulator.reversedResult
                }
