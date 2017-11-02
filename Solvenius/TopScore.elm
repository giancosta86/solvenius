{-§
  ===========================================================================
  Solvenius
  ===========================================================================
  Copyright (C) 2001-2017 Gianluca Costa
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

module Solvenius.TopScore (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Solvenius.GameRules as GameRules

type alias Model =
    GameRules.Score


type Command
    = BackToTitle


view : Model -> Signal.Address Command -> Html
view model commandAddress =
    div
        [ id "topScoreStage"
        ]
        [ h1
            []
            [ text "Top Score"
            ]
        , p
            []
            [ text "Your top score up to now is:"
            ]
        , p
            [ id "topScoreLabel"
            ]
            [ text (toString model)
            ]
        , button
            [ attribute "onclick" "interactiveTopScoreReset()"
            ]
            [ text "Reset"
            ]
        , button
            [ id "backButton", onClick commandAddress BackToTitle
            ]
            [ text "Back"
            ]
        ]
