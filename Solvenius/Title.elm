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

module Solvenius.Title (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal


type Command
    = NewGame
    | ShowTopScore
    | ShowHelp
    | ShowAbout


view : Signal.Address Command -> Html
view commandAddress =
    div
        [ id "titleStage"
        ]
        [ h1
            [ id "titleName"
            ]
            [ text "Solvenius"
            ]
        , h1
            [ id "titleVersion"
            ]
            [ text "3"
            ]
        , button
            [ onClick commandAddress NewGame
            ]
            [ text "New game"
            ]
        , button
            [ onClick commandAddress ShowTopScore
            ]
            [ text "Top score"
            ]
        , button
            [ onClick commandAddress ShowHelp
            ]
            [ text "Help"
            ]
        , button
            [ onClick commandAddress ShowAbout
            ]
            [ text "About"
            ]
        ]
