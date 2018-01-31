module Metrix.Slider.Html exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Collage.Render
import Metrix.Slider.State as State exposing (State)
import Metrix.Slider.Update as Update exposing (Update)
import Metrix.Slider.Collage as Collage
import MouseEvents


unlabeledSlider : Float -> State -> Html Update
unlabeledSlider width state =
  Collage.unlabeledSlider width state |>
  Collage.Render.svg |>
  List.singleton |>
  div
    [
      MouseEvents.onMouseDown
        (\ event -> Debug.log "" <| Update.DragStartedUpdate event.clientPos.x event.targetPos.x),
      style
        [
          ("position", "fixed"),
          ("top", "50%"),
          ("left", "50%"),
          ("margin-left", toString (negate (width / 2)) ++ "px")
        ]
    ]
