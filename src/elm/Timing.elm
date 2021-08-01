module Timing exposing (..)


timerMillis : Float
timerMillis =
    333


formatMillis : Int -> Result String String
formatMillis millis =
    let
        totalSeconds =
            toFloat millis / 1000

        minutes =
            totalSeconds / 60 |> floor

        seconds =
            floor totalSeconds
                |> remainderBy 60

        minutesComponents =
            if minutes > 0 then
                [ String.fromInt minutes, "m " ]

            else
                []

        secondsComponents =
            [ String.fromInt seconds, "s" ]

        components =
            minutesComponents ++ secondsComponents
    in
    if millis >= 0 then
        String.join "" components
            |> Ok

    else
        Err "Milliseconds must be >= 0"
