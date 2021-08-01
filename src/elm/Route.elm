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


siteRoot: String
siteRoot = "solvenius"

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
        ["/", siteRoot, "/", routeString] |> String.join "" 


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
    let
        rootPath path =
            s siteRoot </> s path
    in
    oneOf
        [ map Home <| s siteRoot
        , map Game <| rootPath game
        , map Settings <| rootPath settings
        , map TopScore <| rootPath topScore
        , map Help <| rootPath help
        , map About <| rootPath about
        ]
