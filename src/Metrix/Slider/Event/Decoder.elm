module Metrix.Slider.Event.Decoder exposing (..)

import Json.Decode exposing (..)
import Metrix.Slider.Event.Types exposing (..)
import Native.Events


mouseEvent : Decoder MouseDownEvent
mouseEvent =
    map2 (\mousePosition elementPosition -> { mousePosition = mousePosition, elementPosition = elementPosition })
        clientPosition
        currentTargetClientPosition


currentTargetClientPosition : Decoder Position
currentTargetClientPosition =
    field "currentTarget"
        (map (Native.Events.elementClientPosition >> (\p -> ( p.x, p.y ))) value)


clientPosition : Decoder Position
clientPosition =
    map2 (,)
        (field "clientX" int)
        (field "clientY" int)


allFieldsWithDefault : Decoder a -> Decoder (List ( String, Maybe a ))
allFieldsWithDefault fieldDec =
    keyValuePairs (oneOf [ map Just fieldDec, succeed Nothing ])
