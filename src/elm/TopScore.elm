port module TopScore exposing (Model, Msg(..), resetTopScore, saveTopScore, topScoreChanged, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Route
import Score exposing (Score)
import Utils.Html exposing (asButton, buttonLink, page)


port saveTopScore : Score -> Cmd msg


port resetTopScore : () -> Cmd msg


port topScoreChanged : (Score -> msg) -> Sub msg


type alias Model =
    Score


type Msg
    = Reset


view : Model -> Browser.Document Msg
view model =
    { title = "Solvenius - Top Score"
    , body =
        [ page [ class "topScore" ]
            [ h1 [ class "label" ] [ text "Your top score is:" ]
            , div [ class "topScoreBox" ]
                [ span [] [ model |> Score.toString |> text ]
                ]
            , div
                [ onClick Reset
                , if model > 0 then
                    asButton

                  else
                    style "display" "none"
                ]
                [ text "🗑️ Reset" ]
            , buttonLink Route.Home [] "🏠 Home"
            ]
        ]
    }
