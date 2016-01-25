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

module Solvenius.About (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown


type Command
    = BackToTitle


view : Signal.Address Command -> Html
view commandAddress =
    div
        [ id "aboutStage"
        ]
        [ h1
            []
            [ text "Solvenius 3.1"
            ]
        , p
            []
            [ text "Solvenius 3 is an open source HTML 5 game created using Elm, "
            , text "a functional reactive programming language."
            ]
        , p
            []
            [ text "Copyright © 2001-2016 Gianluca Costa."
            ]
        , h3
            []
            [ text "Music credits"
            ]
        , Markdown.toHtml """
* "Winner Winner!" Kevin MacLeod ([incompetech.com](http://incompetech.com))
Licensed under Creative Commons: By Attribution 3.0 License
[http://creativecommons.org/licenses/by/3.0/](http://creativecommons.org/licenses/by/3.0/)


**NOTE**: the original MP3 has been compressed when creating the game.
"""
        , button
            [ attribute "onclick" "openGithubPage()"
            ]
            [ text "View on GitHub"
            ]
        , button
            [ attribute "onclick" "openFacebookPage()"
            ]
            [ text "Solvenius on Facebook"
            ]
        , button
            [ onClick commandAddress BackToTitle
            ]
            [ text "Back"
            ]
        ]
