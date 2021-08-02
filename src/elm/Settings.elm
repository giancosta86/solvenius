port module Settings exposing (Model, Msg(..), saveSettings, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Route
import Utils.Html exposing (asButton, buttonLink, page)


type alias Model =
    { musicEnabled : Bool
    , soundsEnabled : Bool
    }


type Msg
    = FlipMusic
    | FlipSounds


port saveSettings : Model -> Cmd msg


view : Model -> Browser.Document Msg
view model =
    { title = "Solvenius - Settings"
    , body =
        [ page [ class "settings" ]
            [ div [ onClick FlipMusic, asButton ]
                [ text
                    (if model.musicEnabled then
                        "🔊🎶 Music is on"

                     else
                        "🔇🎶 Music is off"
                    )
                ]
            , div [ onClick FlipSounds, asButton ]
                [ text
                    (if model.soundsEnabled then
                        "🔊🔔 Sounds are on"

                     else
                        "🔇🔔 Sounds are off"
                    )
                ]
            , buttonLink Route.Home [] "🏠 Home"
            ]
        ]
    }
