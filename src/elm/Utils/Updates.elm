module Utils.Updates exposing (..)


type alias UpdateResult msg model =
    ( model, Cmd msg )


type alias UpdateFunction msg model =
    msg -> model -> UpdateResult msg model


pipeUpdate : UpdateFunction msg model -> msg -> UpdateResult msg model -> UpdateResult msg model
pipeUpdate nextUpdate msg latestUpdateResult =
    let
        ( latestModel, latestCmd ) =
            latestUpdateResult

        ( nextModel, nextCmd ) =
            nextUpdate msg latestModel

        actualNextCmd =
            Cmd.batch [ latestCmd, nextCmd ]
    in
    ( nextModel, actualNextCmd )
