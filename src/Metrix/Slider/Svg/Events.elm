module Metrix.Slider.Svg.Events exposing (..)

import Svg exposing (Attribute)
import Svg.Events exposing (..)
import Metrix.Slider.Event.Decoder as EventDecoder
import Metrix.Slider.Event.Types as EventTypes
import Json.Decode
import Mouse


onMouseDownWithDetails : (EventTypes.MouseDownEvent -> msg) -> Attribute msg
onMouseDownWithDetails msg =
  on "mousedown" (Json.Decode.map msg EventDecoder.mouseEvent)
