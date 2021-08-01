module DigitStatus exposing (DigitStatus(..), toString)


type DigitStatus
    = Matching
    | Misplaced
    | Unused


toString : DigitStatus -> String
toString digitStatus =
    case digitStatus of
        Matching ->
            "Matching"

        Misplaced ->
            "Misplaced"

        Unused ->
            "Unused"
