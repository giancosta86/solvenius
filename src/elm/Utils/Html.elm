module Utils.Html exposing (asButton, buttonLink, link, mapDocument, page, textPage)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Route exposing (Route)


link : Route -> List (Attribute msg) -> String -> Html msg
link route attributes linkText =
    let
        hrefAttribute =
            Route.getPath route |> href
    in
    a (hrefAttribute :: attributes) [ text linkText ]


buttonLink : Route -> List (Attribute msg) -> String -> Html msg
buttonLink route attributes linkText =
    link route (asButton :: attributes) linkText


page : List (Attribute msg) -> List (Html msg) -> Html msg
page attributes children =
    div (class "page" :: attributes) children


textPage : List (Attribute msg) -> List (Html msg) -> Html msg
textPage attributes children =
    page (class "textPage" :: attributes)
        [ div [ class "content" ]
            children
        , buttonLink Route.Home [] "🏠 Home"
        ]


asButton : Attribute msg
asButton =
    class "button"


mapDocument : (a -> b) -> Browser.Document a -> Browser.Document b
mapDocument mapper document =
    { title = document.title
    , body = List.map (Html.map mapper) document.body
    }
