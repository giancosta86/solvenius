module Game.View exposing (view)

import Browser
import Digit exposing (Digit(..))
import DigitStatus exposing (DigitStatus(..))
import Game.Data exposing (Attempt, Model, Msg(..), gameOver)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Route
import Score
import Sequence exposing (Sequence)
import Timing
import Utils.Html exposing (asButton, buttonLink, page)


sequenceDisplay : Int -> Sequence -> Html Msg
sequenceDisplay expectedLength userSequence =
    let
        sequenceChars =
            userSequence
                |> List.map Digit.toString

        missingChars =
            "_"
                |> List.repeat (expectedLength - List.length userSequence)
    in
    div [ class "sequenceDisplay" ] [ sequenceChars ++ missingChars |> String.join " " |> text ]


sequenceButton : List (Html.Attribute Msg) -> String -> Html Msg
sequenceButton attributes label =
    div
        (class "sequenceButton" :: asButton :: attributes)
        [ span [] [ label |> text ]
        ]


digitButton : Digit -> Html Msg
digitButton digit =
    Digit.toString digit
        |> sequenceButton [ onClick (PushDigit digit) ]


popDigitButton : Html Msg
popDigitButton =
    "<"
        |> sequenceButton [ onClick PopDigit ] 


sequenceButtonsBox : Html Msg
sequenceButtonsBox =
    div [ class "sequenceButtonsBox" ]
        [ div []
            ([ One, Two, Three ]
                |> List.map digitButton
            )
        , div []
            ([ Four, Five, Six ]
                |> List.map digitButton
            )
        , div []
            ([ Seven, Eight, Nine ]
                |> List.map digitButton
            )
        , div [] [ digitButton Zero, popDigitButton ]
        ]


attemptRow : Attempt -> Html Msg
attemptRow attempt =
    let
        cssClass digitStatus =
            digitStatus
                |> DigitStatus.toString
                |> String.toLower

        digitSpan ( digit, status ) =
            span [ cssClass status |> class ] [ digit |> Digit.toString |> text ]
    in
    List.map digitSpan attempt
        |> div [ class "attemptRow" ]


attemptsArea : List Attempt -> Html Msg
attemptsArea attempts =
    List.map attemptRow attempts
        |> div [ class "attemptsArea" ]


view : Model -> Browser.Document Msg
view model =
    let
        gameScreen =
            if model.paused then
                pauseScreen

            else if model.stopping then
                stopRequestScreen model

            else if gameOver model then
                gameOverScreen model

            else
                playingScreen model
    in
    { title = "Solvenius"
    , body =
        [ gameScreen |> page [ class "game" ]
        ]
    }


playingScreen : Model -> List (Html Msg)
playingScreen model =
    [ div [ class "info" ]
        [ span [] [ "Score: " ++ Score.toString model.score |> text ]
        , span [ class "timeLabel" ] 
            [ text ("Time: " ++ (
                Timing.formatMillis model.remainingMillis 
                    |> Result.toMaybe 
                    |> Maybe.withDefault ""
                )
            )]
        ]
    , sequenceDisplay model.expectedLength model.userSequence
    , attemptsArea model.attemptsForSequence
    , sequenceButtonsBox
    , div [ class "controlButtonsBox" ]
        [ div [ onClick Pause, asButton ] [ text "⏸️ Pause" ]
        , div [ onClick RequestStopGame, asButton ] [ text "⏹️ Exit" ]
        ]
    ]


stopRequestScreen : Model -> List (Html Msg)
stopRequestScreen _ =
    [ h1 [] [ text "Stop the game?" ]
    , div [ onClick CancelStopGame, asButton ] [ text "▶️ Resume" ]
    , div [ onClick StopGame, asButton ] [ text "⏹️ Exit" ]
    ]


pauseScreen : List (Html Msg)
pauseScreen =
    [ h1 [] [ text "Game paused" ]
    , div [ onClick Resume, asButton ] [ text "▶️ Resume" ]
    ]


gameOverScreen : Model -> List (Html Msg)
gameOverScreen model =
    [ h1 [] [ text "Game over!" ]
    , div []
        [ div [] [ "Your score is: " ++ String.fromInt model.score |> text ]
        , div []
            [ (if model.score > model.topScore then
                "🌟 New top score! 🌟"

               else
                ""
              )
                |> text
            ]
        ]
    , buttonLink Route.Game [] "🔃 Play again"
    , buttonLink Route.Home [] "🏠 Home"
    ]
