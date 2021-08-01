module Help exposing (Model, Msg, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Utils.Html exposing (textPage)


type alias Model =
    ()


type alias Msg =
    ()


view : Model -> Browser.Document Msg
view () =
    { title = "Solvenius - Reference"
    , body =
        [ textPage [ class "help" ]
            [ p [] [ text "Deduce as many sequences as you can, before the time runs out!" ]
            , p [] [ text "When the game starts, you'll have to infer a sequence of 2 digits; as the game goes on, sequences grow longer and longer - up to 9 digits: the objective is to make a score greater than your previous top score." ]
            , p [] [ text "Wrong input sequences will give you clues on the actual secret sequence; every digit will be:" ]
            , ul []
                [ li [] [ text "GREEN if it is exactly in that position in the secret sequence" ]
                , li [] [ text "YELLOW (and underlined) if it is in the secret sequence, but in another position" ]
                , li [] [ text "RED (and stricken-through) if it is not in the secret sequence" ]
                ]
            , p [] [ text "Inferring the right sequence will make you earn points (the quicker you are, the more points you'll receive) and further time." ]
            , p [] [ text "There are no limits on the number of attempts you can perform; but time flows, making the game end as the countdown reaches 0." ]
            ]
        ]
    }
