module Metrix.Slider.Internal.Decoder exposing (..)

import DOM exposing (Rectangle)
import Json.Decode as Json exposing (Decoder)


decodeGeometry : Decoder { rect : Rectangle, pageX : Float }
decodeGeometry =
    Json.map2 (\rect pageX -> { rect = rect, pageX = pageX })
        decodeRect
        decodePageX


hasClass : String -> Decoder Bool
hasClass class =
    Json.map
        (\className ->
            String.contains (" " ++ class ++ " ") (" " ++ className ++ " ")
        )
        (Json.at [ "className" ] Json.string)


decodeRect : Decoder Rectangle
decodeRect =
    let
        traverseToContainer decoder =
            hasClass "slider-wrapper"
                |> Json.andThen
                    (\doesHaveClass ->
                        if doesHaveClass then
                            decoder
                        else
                            DOM.parentElement (Json.lazy (\_ -> traverseToContainer decoder))
                    )
    in
    DOM.target <|
        traverseToContainer <|
            DOM.boundingClientRect


decodePageX : Decoder Float
decodePageX =
    Json.at [ "pageX" ] Json.float
