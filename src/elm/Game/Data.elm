module Game.Data exposing (Attempt, Model, Msg(..), gameOver, init, update)

import Audio
import Digit exposing (Digit(..))
import DigitStatus exposing (DigitStatus(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random
import Score exposing (Score)
import Sequence exposing (Sequence)


type alias Attempt =
    List ( Digit, DigitStatus )


type alias Model =
    { expectedLength : Int
    , expectedSequence : Sequence
    , userSequence : Sequence
    , attemptsForSequence : List Attempt
    , millisForSequence : Int
    , remainingMillis : Int
    , latestTickMillis : Maybe Int
    , solvedSequencesOfExpectedLength : Int
    , topScore : Score
    , score : Score
    , paused : Bool
    , stopping : Bool
    }


type Msg
    = PushDigit Digit
    | PopDigit
    | ExpectedSequenceReady Sequence
    | Pause
    | Resume
    | RequestStopGame
    | CancelStopGame
    | StopGame
    | KeyPressed String
    | TimerTick Int


gameOver : Model -> Bool
gameOver model =
    model.remainingMillis <= 0


canUserGuess : Model -> Bool
canUserGuess model =
    not (gameOver model) && not model.stopping && not model.paused && not (List.isEmpty model.expectedSequence)


digitGenerator : Random.Generator Digit
digitGenerator =
    Random.uniform Zero [ One, Two, Three, Four, Five, Six, Seven, Eight, Nine ]


generateExpectedSequence : Int -> Cmd Msg
generateExpectedSequence length =
    digitGenerator
        |> Random.list length
        |> Random.generate ExpectedSequenceReady


init : Score -> ( Model, Cmd Msg )
init topScore =
    let
        initialModel =
            { expectedLength = 2
            , expectedSequence = []
            , userSequence = []
            , attemptsForSequence = []
            , millisForSequence = 0
            , remainingMillis = 30000
            , latestTickMillis = Nothing
            , solvedSequencesOfExpectedLength = 0
            , topScore = topScore
            , score = 0
            , paused = False
            , stopping = False
            }

        initialCmd =
            generateExpectedSequence initialModel.expectedLength
    in
    ( initialModel, initialCmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PushDigit digit ->
            handlePushDigit digit model

        PopDigit ->
            handlePopDigit model

        ExpectedSequenceReady expectedSequence ->
            ( { model | expectedSequence = expectedSequence }
            , Cmd.none
            )

        Pause ->
            ( { model
                | paused = True
                , latestTickMillis = Nothing
              }
            , Cmd.none
            )

        Resume ->
            ( { model | paused = False }
            , Cmd.none
            )

        RequestStopGame ->
            ( { model
                | stopping = True
                , latestTickMillis = Nothing
              }
            , Cmd.none
            )

        CancelStopGame ->
            ( { model | stopping = False }, Cmd.none )

        StopGame ->
            ( { model | stopping = False, remainingMillis = 0 }, Cmd.none )

        KeyPressed key ->
            handleKeyPressed key model

        TimerTick millis ->
            handleTimerTick millis model


handlePushDigit : Digit -> Model -> ( Model, Cmd Msg )
handlePushDigit digit model =
    if canUserGuess model then
        let
            nextUserSequence =
                model.userSequence ++ [ digit ]

            modelWithNextUserSequence =
                { model | userSequence = nextUserSequence }
        in
        if List.length nextUserSequence == List.length model.expectedSequence then
            validateFullUserSequence modelWithNextUserSequence

        else
            ( modelWithNextUserSequence
            , Cmd.none
            )

    else
        ( model, Cmd.none )


validateFullUserSequence : Model -> ( Model, Cmd Msg )
validateFullUserSequence model =
    let
        digitStatuses =
            Sequence.compareSequences model.expectedSequence model.userSequence
                |> Result.toMaybe
                |> Maybe.withDefault []

        perfectMatch =
            List.all ((==) DigitStatus.Matching) digitStatuses
    in
    if perfectMatch then
        updateOnPerfectMatch model

    else
        let
            attempt =
                List.map2 Tuple.pair model.userSequence digitStatuses
        in
        ( { model
            | userSequence = []
            , attemptsForSequence = attempt :: model.attemptsForSequence
          }
        , Cmd.none
        )


updateOnPerfectMatch : Model -> ( Model, Cmd Msg )
updateOnPerfectMatch model =
    let
        nextScore =
            model.score
                + additionalScoreOnPerfectMatch model.expectedLength model.millisForSequence

        nextSolvedSequencesOfExpectedLength =
            model.solvedSequencesOfExpectedLength + 1 |> modBy model.expectedLength

        nextExpectedLength =
            if nextSolvedSequencesOfExpectedLength == 0 then
                model.expectedLength + 1 |> Basics.min 9

            else
                model.expectedLength

        nextRemainingMillis =
            model.remainingMillis + additionalMillisOnPerfectMatch model.expectedLength
    in
    ( { model
        | expectedLength = nextExpectedLength
        , expectedSequence = []
        , userSequence = []
        , attemptsForSequence = []
        , millisForSequence = 0
        , remainingMillis = nextRemainingMillis
        , solvedSequencesOfExpectedLength = nextSolvedSequencesOfExpectedLength
        , score = nextScore
      }
    , Cmd.batch
        [ generateExpectedSequence nextExpectedLength
        , Audio.playSound "perfectMatch.mp3"
        ]
    )


additionalScoreOnPerfectMatch : Int -> Int -> Score
additionalScoreOnPerfectMatch expectedLength millisForSequence =
    let
        secondsForSequence =
            millisForSequence // 1000
    in
    6
        * expectedLength
        - secondsForSequence
        |> Basics.max 0
        |> (+) expectedLength


additionalMillisOnPerfectMatch : Int -> Int
additionalMillisOnPerfectMatch expectedLength =
    3000 * expectedLength


handlePopDigit : Model -> ( Model, Cmd Msg )
handlePopDigit model =
    if canUserGuess model then
        ( { model
            | userSequence =
                model.userSequence
                    |> List.take (List.length model.userSequence - 1)
          }
        , Cmd.none
        )

    else
        ( model, Cmd.none )


handleKeyPressed : String -> Model -> ( Model, Cmd Msg )
handleKeyPressed key model =
    let
        actualMsg : Maybe Msg
        actualMsg =
            case key of
                "0" ->
                    Just (PushDigit Zero)

                "1" ->
                    Just (PushDigit One)

                "2" ->
                    Just (PushDigit Two)

                "3" ->
                    Just (PushDigit Three)

                "4" ->
                    Just (PushDigit Four)

                "5" ->
                    Just (PushDigit Five)

                "6" ->
                    Just (PushDigit Six)

                "7" ->
                    Just (PushDigit Seven)

                "8" ->
                    Just (PushDigit Eight)

                "9" ->
                    Just (PushDigit Nine)

                "Backspace" ->
                    Just PopDigit

                _ ->
                    Nothing
    in
    actualMsg
        |> Maybe.map (\msg -> update msg model)
        |> Maybe.withDefault ( model, Cmd.none )


handleTimerTick : Int -> Model -> ( Model, Cmd Msg )
handleTimerTick millis model =
    if canUserGuess model then
        let
            millisSinceLatestTick =
                millis - Maybe.withDefault millis model.latestTickMillis

            nextRemainingMillis =
                (model.remainingMillis - millisSinceLatestTick)
                    |> Basics.max 0

            nextModel =
                { model
                    | millisForSequence = model.millisForSequence + millisSinceLatestTick
                    , remainingMillis = nextRemainingMillis
                    , latestTickMillis = Just millis
                }
        in
        ( nextModel, Cmd.none )

    else
        ( model, Cmd.none )
