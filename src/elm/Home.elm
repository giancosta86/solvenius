module Home exposing (Model, Msg, view)

import Browser exposing (UrlRequest(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Utils.Html exposing (buttonLink, page)
import Route


type alias Model =
    ()


type alias Msg =
    ()


view : Model -> Browser.Document Msg
view () =
    { title = "Solvenius"
    , body =
        [ page [ class "home" ]
            [ h1 [] [ text "Solvenius 4" ]
            , div [ class "links" ]
                [ buttonLink Route.Game [] "▶️ Play!"
                , buttonLink Route.Settings [] "⚙️ Settings"
                , buttonLink Route.TopScore [] "🏆 Top score"
                , buttonLink Route.Help [] "❓ Help"
                , buttonLink Route.About [] "ℹ️ About..."
                ]
            ]
        ]
    }
