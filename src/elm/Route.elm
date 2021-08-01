module Route exposing (Route(..), getPath, parseRoute)

import Url exposing (Url)
import Url.Parser exposing (..)


type Route
    = Home
    | Game
    | Settings
    | TopScore
    | Help
    | About
    | NotFound


getPath : Route -> String
getPath route =
    let
        routeString =
            case route of
                Home ->
                    home

                Game ->
                    game

                Settings ->
                    settings

                TopScore ->
                    topScore

                Help ->
                    help

                About ->
                    about

                NotFound ->
                    notFound
    in
    "/" ++ routeString


home : String
home =
    ""


game : String
game =
    "game"


settings : String
settings =
    "settings"


topScore : String
topScore =
    "top-score"


help : String
help =
    "help"


about : String
about =
    "about"


notFound : String
notFound =
    "not-found"


parseRoute : Url -> Route
parseRoute url =
    parse routeParser url
        |> Maybe.withDefault NotFound


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Home top
        , map Game <| s game
        , map Settings <| s settings
        , map TopScore <| s topScore
        , map Help <| s help
        , map About <| s about
        ]
