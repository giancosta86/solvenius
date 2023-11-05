module About exposing (Model, Msg, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Utils.Html exposing (textPage)


type alias Model =
    { version : String }


type alias Msg =
    ()


attribution : String -> Html Msg
attribution licenseText =
    li [ class "attribution" ] [ text licenseText ]


view : Model -> Browser.Document Msg
view model =
    { title = "About Solvenius..."
    , body =
        [ textPage [ class "about" ]
            [ p
                []
                [ "Solvenius 4 (v" ++ model.version ++ ") is an open source app created using the Elm language." |> text
                ]
            , p
                []
                [ text "Copyright © 2001-2023 Gianluca Costa."
                ]
            , p
                []
                [ span [] [ text "To explore the source code, please visit the " ]
                , a [ href "https://github.com/giancosta86/solvenius" ] [ text "GitHub repository" ]
                , span [] [ text "." ]
                ]
            , h3
                []
                [ text "Audio credits"
                ]
            , ul []
                [ attribution "The Entertainer by Kevin MacLeod\nLink: https://incompetech.filmmusic.io/song/5765-the-entertainer\nLicense: https://filmmusic.io/standard-license"
                , attribution "Frogs Legs Rag by Kevin MacLeod\nLink: https://incompetech.filmmusic.io/song/5761-frogs-legs-rag\nLicense: https://filmmusic.io/standard-license"
                , attribution "Ding sound\nLink: https://djlunatique.com/ding-sound-effect/\nLicense: https://creativecommons.org/publicdomain/zero/1.0/"
                ]
            , p [] [ text "NOTE: the original audio files have been compressed when creating the game." ]
            ]
        ]
    }
