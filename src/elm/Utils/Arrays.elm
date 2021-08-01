module Utils.Arrays exposing (findIndexFrom)

import Array exposing (Array)


findIndexFrom : a -> Array a -> Int -> Maybe Int
findIndexFrom elementToFind elements startIndex =
    Array.get startIndex elements
        |> Maybe.map ((==) elementToFind)
        |> Maybe.andThen
            (\value ->
                if value then
                    Just startIndex

                else
                    findIndexFrom elementToFind elements (startIndex + 1)
            )
