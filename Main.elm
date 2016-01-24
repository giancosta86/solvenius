{-§
  ===========================================================================
  Solvenius
  ===========================================================================
  Copyright (C) 2001-2016 Gianluca Costa
  ===========================================================================
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
       http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
  ===========================================================================
--}

module Main (..) where

import Signal
import Time
import Html exposing (..)
import Solvenius.Title as Title
import Solvenius.Game as Game
import Solvenius.TopScore as TopScore
import Solvenius.Help as Help
import Solvenius.About as About
import Solvenius.GameRules as GameRules


port topScoreInput : Signal TopScore.Model


port scoreOutput : Signal GameRules.Score
port scoreOutput =
  Signal.map mapCommandToScoreOutput commandMailbox.signal


mapCommandToScoreOutput : Command -> GameRules.Score
mapCommandToScoreOutput command =
    case command of
        GameCommand (Game.BackToTitle score) ->
            score

        _ ->
            0


type State
    = InTitle
    | InGame Game.Model
    | InTopScore
    | InHelp
    | InAbout


type alias Model =
    { state : State
    , topScore : TopScore.Model
    }


type Command
    = Nop
    | TitleCommand Title.Command
    | GameCommand Game.Command
    | TopScoreCommand TopScore.Command
    | HelpCommand Help.Command
    | AboutCommand About.Command
    | TimeTick Time.Time
    | TopScoreInput TopScore.Model


commandMailbox : Signal.Mailbox Command
commandMailbox =
    Signal.mailbox Nop


command : Signal.Signal Command
command =
    Signal.mergeMany
        [ (Signal.map TopScoreInput topScoreInput)
        , commandMailbox.signal
        , (Signal.map TimeTick (Time.every Time.millisecond))
        ]


updateModel : Command -> Model -> Model
updateModel command model =
    case command of
        TopScoreInput topScore ->
            { model
                | topScore =
                    topScore
            }

        _ ->
            case model.state of
                InTitle ->
                    case command of
                        TitleCommand titleCommand ->
                            case titleCommand of
                                Title.NewGame ->
                                    { model
                                        | state =
                                            InGame Game.initModel
                                    }

                                Title.ShowTopScore ->
                                    { model
                                        | state =
                                            InTopScore
                                    }

                                Title.ShowHelp ->
                                    { model
                                        | state =
                                            InHelp
                                    }

                                Title.ShowAbout ->
                                    { model
                                        | state =
                                            InAbout
                                    }

                        _ ->
                            model

                InGame gameModel ->
                    case command of
                        GameCommand gameCommand ->
                            case gameCommand of
                                Game.BackToTitle score ->
                                    { model
                                        | topScore =
                                            if score > model.topScore then
                                                score
                                            else
                                                model.topScore
                                        , state =
                                            InTitle
                                    }

                                _ ->
                                    { model
                                        | state =
                                            InGame (Game.updateModel gameCommand gameModel)
                                    }

                        TimeTick time ->
                            { model
                                | state =
                                    InGame (Game.updateModel (Game.TimeTick time) gameModel)
                            }

                        _ ->
                            model

                InTopScore ->
                    case command of
                        TopScoreCommand (TopScore.BackToTitle) ->
                            { model
                                | state =
                                    InTitle
                            }

                        _ ->
                            model

                InHelp ->
                    case command of
                        HelpCommand (Help.BackToTitle) ->
                            { model
                                | state =
                                    InTitle
                            }

                        _ ->
                            model

                InAbout ->
                    case command of
                        AboutCommand (About.BackToTitle) ->
                            { model
                                | state =
                                    InTitle
                            }

                        _ ->
                            model


view : Model -> Html
view model =
  case model.state of
      InTitle ->
          let
            titleAddress =
              Signal.forwardTo commandMailbox.address (\titleCommand -> TitleCommand titleCommand)
          in
            Title.view titleAddress

      InGame gameModel ->
          let
            gameAddress =
                Signal.forwardTo commandMailbox.address (\gameCommand -> GameCommand gameCommand)
          in
            Game.view gameModel gameAddress

      InTopScore ->
          let
            topScoreAddress =
                Signal.forwardTo commandMailbox.address (\topScoreCommand -> TopScoreCommand topScoreCommand)
          in
            TopScore.view model.topScore topScoreAddress

      InHelp ->
          let
            helpAddress =
                Signal.forwardTo commandMailbox.address (\helpCommand -> HelpCommand helpCommand)
          in
            Help.view helpAddress

      InAbout ->
          let
            aboutAddress =
                Signal.forwardTo commandMailbox.address (\aboutCommand -> AboutCommand aboutCommand)
          in
            About.view aboutAddress


initModel : Model
initModel =
    { state =
        InTitle
    , topScore =
        0
    }


main : Signal Html
main =
    Signal.map view (Signal.foldp updateModel initModel command)
