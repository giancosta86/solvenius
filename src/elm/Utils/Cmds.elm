module Utils.Cmds exposing (conditionalBatch)


conditionalBatch : Bool -> Cmd msg -> Cmd msg -> Cmd msg
conditionalBatch condition base additional =
    if condition then
        Cmd.batch
            [ base
            , additional
            ]

    else
        base
