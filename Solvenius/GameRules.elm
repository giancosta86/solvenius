{-§
  ===========================================================================
  Solvenius
  ===========================================================================
  Copyright (C) 2001-2016 Gianluca Costa
  ===========================================================================
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
       http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
  ===========================================================================
--}

module Solvenius.GameRules (..) where

import List
import Char
import Debug
import Maybe exposing (..)
import Random


type alias Score =
    Int


type alias Digit =
    Char


type alias Sequence =
    List Char


type DigitResult
    = DigitOk
    | DigitMisplaced
    | DigitWrong


type alias SequenceResult =
    List DigitResult


type alias SequenceLogItem =
    ( Sequence, SequenceResult )


type alias SequenceLog =
    List SequenceLogItem


assertValue : Maybe a -> a
assertValue option =
    case option of
        Just value ->
            value

        Nothing ->
            Debug.crash ("Value expected but Nothing was found")


checkSequenceInternal : Sequence -> Sequence -> Sequence -> SequenceResult -> SequenceResult
checkSequenceInternal inputList secretList fullSecretList outputBuffer =
    if (List.length inputList) /= (List.length secretList) then
        Debug.crash
            ("inputList and secretList have different sizes! "
                ++ (toString (List.length inputList))
                ++ " VS "
                ++ (toString (List.length secretList))
            )
    else if inputList == [] then
        List.reverse outputBuffer
    else
        let
            inputHead =
                assertValue (List.head inputList)

            inputTail =
                assertValue (List.tail inputList)

            secretHead =
                assertValue (List.head secretList)

            secretTail =
                assertValue (List.tail secretList)

            digitResult =
                if inputHead == secretHead then
                    DigitOk
                else if List.member inputHead fullSecretList then
                    DigitMisplaced
                else
                    DigitWrong
        in
            checkSequenceInternal inputTail secretTail fullSecretList (digitResult :: outputBuffer)


checkSequence : Sequence -> Sequence -> SequenceResult
checkSequence inputSequence secretSequence =
    checkSequenceInternal inputSequence secretSequence secretSequence []


generateSequence : Int -> Int -> Sequence
generateSequence length seed =
    let
        intToDigitChar intSource =
            Char.fromCode ((Char.toCode '0') + intSource)

        digitGenerator =
            Random.map intToDigitChar (Random.int 0 9)

        sequenceGenerator =
            Random.list length digitGenerator

        ( sequence, _ ) = Random.generate sequenceGenerator (Random.initialSeed seed)
    in
        sequence


updateScore : Score -> Sequence -> Int -> Score
updateScore currentScore correctSequence elapsedSecondsForSequence =
    let
        sequenceLength =
            toFloat (List.length correctSequence)

        deltaScore =
            sequenceLength + 6 * sequenceLength / toFloat (elapsedSecondsForSequence + 1)
    in
        currentScore + (ceiling deltaScore)


updateSecondsToPlay : Int -> Sequence -> Int -> Int
updateSecondsToPlay currentSecondsToPlay correctSequence correctSequencesOfCurrentLength =
    let
        sequenceLength = toFloat (List.length correctSequence)

        seriesLength = toFloat correctSequencesOfCurrentLength

        deltaSeconds = 5 * sequenceLength + (sequenceLength / 5) * seriesLength
    in
        currentSecondsToPlay + (ceiling deltaSeconds)
