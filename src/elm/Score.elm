module Score exposing (Score, toString)


type alias Score =
    Int


toString : Score -> String
toString score =
    String.fromInt score
