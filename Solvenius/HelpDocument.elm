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

module Solvenius.HelpDocument (..) where

import Html exposing (..)
import Markdown


helpContent : Html
helpContent =
    Markdown.toHtml """

# Help

**Deduce as many sequences as you can, before the time runs out!**

When the game starts, you'll have to infer a sequence of *2 digits*; as the game goes on, sequences grow longer and longer - up to *9 digits*: the objective is to make a score greater than your previous top score.

There are no limits on the number of attempts you can perform; but time flows, making the game end as the countdown reaches 0.

Wrong input sequences will give you clues on the actual secret sequence; every digit will be:

* *green* if it is exactly in that position in the secret sequence

* *yellow* (and *underlined*) if it is in the secret sequence, but in another position

* *red* (and *stricken-through*, in *italic* style) if it is not in the secret sequence


Inferring the right sequence will make you earn points (the quicker you are, the more points you'll receive) and further time.
"""
