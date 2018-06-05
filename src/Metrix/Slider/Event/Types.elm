module Metrix.Slider.Event.Types exposing (..)


type alias MouseDownEvent =
    { mousePosition : Position, elementPosition : Position }


type alias Position =
    ( Int, Int )
