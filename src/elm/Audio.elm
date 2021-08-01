port module Audio exposing (playMusic, playSound)



port playMusic : String -> Cmd msg


port playSound : String -> Cmd msg
