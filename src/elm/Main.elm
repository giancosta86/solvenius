module Main exposing (main)

import About exposing (Model)
import Audio
import Browser exposing (UrlRequest(..))
import Browser.Events
import Browser.Navigation as Nav
import Game.Data
import Game.View
import Help
import Home
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode
import NotFound
import Route
import Score exposing (Score)
import Settings
import Time
import Timing
import TopScore
import Url exposing (Url)
import Utils.Cmds exposing (conditionalBatch)
import Utils.Html
import Utils.Updates exposing (pipeUpdate)


type alias Flags =
    { initialTopScore : Score
    , initialSettings : Settings.Model
    , version : String
    }


type RouteState
    = InHome
    | InGame Game.Data.Model
    | InSettings
    | InTopScore
    | InHelp
    | InAbout
    | InNotFound


type alias Model =
    { navKey : Nav.Key
    , topScore : Score
    , settings : Settings.Model
    , version : String
    , routeState : RouteState
    , music : Maybe String
    }


type Msg
    = HomeMsg Home.Msg
    | GameMsg Game.Data.Msg
    | SettingsMsg Settings.Msg
    | TopScoreMsg TopScore.Msg
    | HelpMsg Help.Msg
    | AboutMsg About.Msg
    | NotFoundMsg NotFound.Msg
    | UrlRequested UrlRequest
    | UrlChanged Url
    | KeyPressed String
    | TimerTick Int
    | TopScoreChanged Score


init : Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags initialUrl navKey =
    let
        initialModel : Model
        initialModel =
            { navKey = navKey
            , topScore = flags.initialTopScore
            , settings = flags.initialSettings
            , version = flags.version
            , routeState = InHome
            , music = Nothing
            }
    in
    loadUrl initialUrl initialModel


loadUrl : Url -> Model -> ( Model, Cmd Msg )
loadUrl url model =
    let
        ( nextRouteState, routeCmd ) =
            case Route.parseRoute url of
                Route.Home ->
                    ( InHome, Cmd.none )

                Route.Game ->
                    Game.Data.init model.topScore
                        |> Tuple.mapBoth InGame (Cmd.map GameMsg)

                Route.Settings ->
                    ( InSettings, Cmd.none )

                Route.TopScore ->
                    ( InTopScore, Cmd.none )

                Route.Help ->
                    ( InHelp, Cmd.none )

                Route.About ->
                    ( InAbout, Cmd.none )

                Route.NotFound ->
                    ( InNotFound, Cmd.none )

        nextMusic =
            case nextRouteState of
                InGame _ ->
                    Just "game.mp3"

                _ ->
                    Just "title.mp3"

        nextModel =
            { model
                | routeState = nextRouteState
                , music = nextMusic
            }

        nextCmd =
            (nextMusic |> Maybe.withDefault "" |> Audio.playMusic)
                |> conditionalBatch (nextMusic /= model.music) routeCmd
    in
    ( nextModel, nextCmd )


view : Model -> Browser.Document Msg
view model =
    let
        routeDocument =
            case model.routeState of
                InHome ->
                    Home.view () |> Utils.Html.mapDocument HomeMsg

                InGame gameModel ->
                    Game.View.view gameModel |> Utils.Html.mapDocument GameMsg

                InTopScore ->
                    TopScore.view model.topScore |> Utils.Html.mapDocument TopScoreMsg

                InSettings ->
                    Settings.view model.settings |> Utils.Html.mapDocument SettingsMsg

                InHelp ->
                    Help.view () |> Utils.Html.mapDocument HelpMsg

                InAbout ->
                    About.view { version = model.version } |> Utils.Html.mapDocument AboutMsg

                InNotFound ->
                    NotFound.view () |> Utils.Html.mapDocument NotFoundMsg

        container =
            div [ class "container" ] routeDocument.body
    in
    { routeDocument | body = [ container ] }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    handleMsgGlobally msg model
        |> pipeUpdate handleMsgForRoute msg
        |> pipeUpdate checkForTopScore msg


handleMsgGlobally : Msg -> Model -> ( Model, Cmd Msg )
handleMsgGlobally msg model =
    case msg of
        UrlRequested (Internal url) ->
            ( model
            , Nav.replaceUrl model.navKey (Url.toString url)
            )

        UrlChanged url ->
            loadUrl url model

        UrlRequested (External href) ->
            ( model, Nav.load href )

        SettingsMsg Settings.FlipMusic ->
            updateSettings (\settings -> { settings | musicEnabled = not settings.musicEnabled }) model

        SettingsMsg Settings.FlipSounds ->
            updateSettings (\settings -> { settings | soundsEnabled = not settings.soundsEnabled }) model

        TopScoreMsg TopScore.Reset ->
            ( model, TopScore.resetTopScore () )

        TopScoreChanged topScore ->
            ( { model
                | topScore = topScore
              }
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )


updateSettings : (Settings.Model -> Settings.Model) -> Model -> ( Model, Cmd Msg )
updateSettings settingsUpdater model =
    let
        settings =
            model.settings

        nextSettings =
            settingsUpdater settings

        nextModel =
            { model | settings = nextSettings }
    in
    ( nextModel
    , Settings.saveSettings nextSettings
    )


handleMsgForRoute : Msg -> Model -> ( Model, Cmd Msg )
handleMsgForRoute msg model =
    case ( msg, model.routeState ) of
        ( TimerTick millis, InGame gameModel ) ->
            Game.Data.update (Game.Data.TimerTick millis) gameModel
                |> updateRouteState InGame GameMsg model

        ( KeyPressed key, InGame gameModel ) ->
            Game.Data.update (Game.Data.KeyPressed key) gameModel
                |> updateRouteState InGame GameMsg model

        ( GameMsg gameMsg, InGame gameModel ) ->
            Game.Data.update gameMsg gameModel
                |> updateRouteState InGame GameMsg model

        _ ->
            ( model, Cmd.none )


checkForTopScore : Msg -> Model -> ( Model, Cmd Msg )
checkForTopScore _ model =
    case model.routeState of
        InGame gameModel ->
            if Game.Data.gameOver gameModel && gameModel.score > model.topScore then
                ( { model
                    | topScore = gameModel.score
                  }
                , TopScore.saveTopScore gameModel.score
                )

            else
                ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


type alias RouteStateConstructor a =
    a -> RouteState


type alias MsgConstructor a =
    a -> Msg


updateRouteState :
    RouteStateConstructor routeStateData
    -> MsgConstructor msgData
    -> Model
    -> ( routeStateData, Cmd msgData )
    -> ( Model, Cmd Msg )
updateRouteState routeStateConstructor msgConstructor model updatedRouteValues =
    let
        ( routeStateData, routeCmd ) =
            updatedRouteValues

        routeModel =
            routeStateConstructor routeStateData

        cmd =
            Cmd.map msgConstructor routeCmd

        updatedModel =
            { model | routeState = routeModel }
    in
    ( updatedModel, cmd )


subscriptions : Model -> Sub Msg
subscriptions _ =
    let
        keyDecoder : Decode.Decoder Msg
        keyDecoder =
            Decode.map KeyPressed (Decode.field "key" Decode.string)
    in
    Sub.batch
        [ Browser.Events.onKeyDown keyDecoder
        , Time.every Timing.timerMillis (Time.posixToMillis >> TimerTick)
        , TopScore.topScoreChanged TopScoreChanged
        ]


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
        }
