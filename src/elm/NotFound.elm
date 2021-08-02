module NotFound exposing (Model, Msg, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Route
import Utils.Html exposing (buttonLink, page)


type alias Model =
    ()


type alias Msg =
    ()


view : Model -> Browser.Document Msg
view () =
    { title = "Solvenius - Page not found"
    , body =
        [ page [ class "notFound" ]
            [ div [] [ text "O__o You have requested a missing page!" ]
            , buttonLink Route.Home [] "🏠 Home"
            ]
        ]
    }
