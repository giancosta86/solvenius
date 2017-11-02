{-^
  ===========================================================================
  Solvenius
  ===========================================================================
  Copyright (C) Gianluca Costa
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

module Solvenius.Game (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time
import String
import Char
import Signal
import Solvenius.GameRules exposing (..)


type alias Model =
    { secondsToPlay : Int
    , secondsToPlayCap : Int
    , secondsToPlayAtLatestSuccess : Int
    , score : Score
    , latestTickTime : Time.Time
    , inputSequence : Sequence
    , secretSequence : Sequence
    , secretSequenceLength : Int
    , correctSequencesOfCurrentLength : Int
    , sequenceLog : SequenceLog
    }


initModel : Model
initModel =
    let
        initialSecondsToPlay =
          30

        initialSecretSequenceLength =
          2
    in
        { secondsToPlay =
            initialSecondsToPlay
        , secondsToPlayCap =
            initialSecondsToPlay
        , secondsToPlayAtLatestSuccess =
            initialSecondsToPlay
        , score =
            0
        , latestTickTime =
            0
        , inputSequence =
            []
        , secretSequence =
            []
        , secretSequenceLength =
            initialSecretSequenceLength
        , correctSequencesOfCurrentLength =
            0
        , sequenceLog =
            []
        }


type Command
    = AppendDigit Digit
    | TimeTick Time.Time
    | KeyPressed Char.KeyCode
    | BackToTitle Score


onTick : Time.Time -> Model -> Model
onTick time model =
    let
        deltaFromLatestTickTime =
            time - model.latestTickTime

        isTickTime =
            deltaFromLatestTickTime >= 1000

        secondsToPlay =
            if isTickTime then
                Basics.max (model.secondsToPlay - 1) 0
            else
                model.secondsToPlay

        latestTickTime =
            if isTickTime then
                time
            else
                model.latestTickTime

        secretSequence =
            if model.secretSequence == [] then
                generateSequence model.secretSequenceLength (round (time * 3))
            else
                model.secretSequence
    in
        { model
            | secondsToPlay =
                secondsToPlay
            , latestTickTime =
                latestTickTime
            , secretSequence =
                secretSequence
        }


onAppendDigit : Digit -> Model -> Model
onAppendDigit digit model =
  if model.secretSequence == [] then
    model
  else
    let
        inputSequence =
            model.inputSequence ++ [ digit ]

        isInputSequenceComplete =
            (List.length inputSequence) == model.secretSequenceLength

        isSequenceCorrect =
            isInputSequenceComplete && (inputSequence == model.secretSequence)

        elapsedSecondsForSequence =
            model.secondsToPlayAtLatestSuccess - model.secondsToPlay

        score =
            if isSequenceCorrect then
                updateScore model.score model.secretSequence elapsedSecondsForSequence
            else
                model.score

        correctSequencesOfCurrentLength =
            if isSequenceCorrect then
                model.correctSequencesOfCurrentLength + 1
            else
                model.correctSequencesOfCurrentLength

        mustIncreaseSequenceLength =
            correctSequencesOfCurrentLength == model.secretSequenceLength

        secondsToPlay =
            if isSequenceCorrect then
                updateSecondsToPlay model.secondsToPlay model.secretSequence correctSequencesOfCurrentLength
            else
                model.secondsToPlay

        sequenceLog =
            if isInputSequenceComplete then
                if isSequenceCorrect then
                    []
                else
                    let
                        sequenceResult =
                            checkSequence inputSequence model.secretSequence

                        sequenceLogItem =
                            ( inputSequence, sequenceResult )
                    in
                        sequenceLogItem :: model.sequenceLog
            else
                model.sequenceLog

        secondsToPlayCap =
            if isSequenceCorrect then
                secondsToPlay
            else
                model.secondsToPlayCap

        secondsToPlayAtLatestSuccess =
            if isSequenceCorrect then
              secondsToPlay
            else
              model.secondsToPlayAtLatestSuccess
    in
        { model
            | inputSequence =
                if isInputSequenceComplete then
                    []
                else
                    inputSequence
            , secretSequence =
                if isSequenceCorrect then
                    []
                else
                    model.secretSequence
            , score =
                score
            , correctSequencesOfCurrentLength =
                if mustIncreaseSequenceLength then
                    0
                else
                    correctSequencesOfCurrentLength
            , secretSequenceLength =
                if mustIncreaseSequenceLength then
                    Basics.min (model.secretSequenceLength + 1) 9
                else
                    model.secretSequenceLength
            , sequenceLog =
                sequenceLog
            , secondsToPlay =
                secondsToPlay
            , secondsToPlayCap =
                secondsToPlayCap
            , secondsToPlayAtLatestSuccess =
                secondsToPlayAtLatestSuccess
        }


zeroDigitKeyCode: Char.KeyCode
zeroDigitKeyCode =
  Char.toCode '0'


updateModel : Command -> Model -> Model
updateModel command model =
    if inGame model then
        case command of
            TimeTick time ->
                onTick time model

            AppendDigit digit ->
                onAppendDigit digit model

            KeyPressed keyCode ->
                if (zeroDigitKeyCode <= keyCode) && (keyCode <= zeroDigitKeyCode + 9) then
                  let
                    digit =
                      Char.fromCode keyCode
                  in
                    onAppendDigit digit model
                else
                  model

            _ ->
                model
    else
        model


inGame : Model -> Bool
inGame model =
    model.secondsToPlay > 0


view : Model -> Signal.Address Command -> Html
view model commandAddress =
    if inGame model then
        renderGame model commandAddress
    else
        renderGameOver model commandAddress


renderGame : Model -> Signal.Address Command -> Html
renderGame model commandAddress =
    let
        makeNumberButton digitValue =
            let
                digit =
                    Char.fromCode (zeroDigitKeyCode + digitValue)

                digitString =
                    toString digitValue
            in
                button
                    [ class "digitButton"
                    , onClick commandAddress (AppendDigit digit)
                    ]
                    [ text digitString
                    ]

        topDigitButtons =
            List.map makeNumberButton [1..5]

        bottomDigitButtons =
            List.map makeNumberButton ([6..9] ++ [ 0 ])

        trailingString =
            String.repeat (model.secretSequenceLength - (List.length model.inputSequence)) "_"

        inputText =
            (String.fromList model.inputSequence) ++ trailingString
    in
        div
            [ id "gameStage"
            ]
            [ span
                [ id "scoreLabel"
                ]
                [ text ("Score: " ++ (toString model.score))
                ]
            , span
                [ id "inputSequenceLabel" ]
                [ text inputText ]
            , ul
                [ id "sequenceLog"
                ]
                (List.map renderSequenceLogItem model.sequenceLog)
            , div
                []
                [ div
                    [ class "digitButtonsRow"
                    ]
                    topDigitButtons
                , div
                    [ class "digitButtonsRow"
                    ]
                    bottomDigitButtons
                ]
            , div
                [ id "timeBox"
                ]
                [ meter
                    [ value (toString model.secondsToPlay)
                    , attribute "min" "0"
                    , attribute "low" "10"
                    , attribute "high" "20"
                    , attribute "optimum" (toString (Basics.max 30 model.secondsToPlayCap))
                    , attribute "max" (toString (Basics.max 30 model.secondsToPlayCap))
                    ]
                    []
                , timeLabel model.secondsToPlay
                ]
            , button
                [ id "backButton", onClick commandAddress (BackToTitle model.score)
                ]
                [ text "Leave game"
                ]
            ]


renderSequenceLogItem : SequenceLogItem -> Html
renderSequenceLogItem sequenceLogItem =
    let
        digitResultPairs =
            unpackSequenceLogItem sequenceLogItem

        digitResultOutputs =
            List.map renderDigitResult digitResultPairs
    in
        li
            []
            digitResultOutputs


unpackSequenceLogItem : SequenceLogItem -> List ( Digit, DigitResult )
unpackSequenceLogItem sequenceLogItem =
    let
        sequence =
            fst sequenceLogItem

        sequenceResult =
            snd sequenceLogItem
    in
        List.map2 (,) sequence sequenceResult


timeLabel : Int -> Html
timeLabel totalSeconds =
    let
        minutes =
            totalSeconds // 60

        seconds =
            totalSeconds % 60
    in
        span
            []
            [ text ((toString minutes) ++ " min " ++ (toString seconds) ++ " s")
            ]


renderDigitResult : ( Digit, DigitResult ) -> Html
renderDigitResult ( digit, digitResult ) =
    let
        cssDigitClass =
            case digitResult of
                DigitOk ->
                    "digitOk"

                DigitMisplaced ->
                    "digitMisplaced"

                DigitWrong ->
                    "digitWrong"
    in
        span
            [ classList
                [ ( cssDigitClass, True )
                , ( "outputDigit", True )
                ]
            ]
            [ text (String.fromChar digit)
            ]


renderGameOver : Model -> Signal.Address Command -> Html
renderGameOver model commandAddress =
    div
        [ id "gameOverStage"
        ]
        [ h1
            []
            [ text "Game over!"
            ]
        , p
            []
            [ text "Your score is:"
            ]
        , p
            [ id "finalScoreLabel"
            ]
            [ text (toString model.score)
            ]
        , button
            [ id "backButton", onClick commandAddress (BackToTitle model.score)
            ]
            [ text "Back"
            ]
        ]
