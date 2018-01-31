module Metrix.Slider.Html exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Collage.Render
import Metrix.Slider.State exposing (State)
import Metrix.Slider.Update exposing (Update)
import Metrix.Slider.Collage as Collage


unlabeledSlider : Float -> State -> Html Update
unlabeledSlider width state =
  Collage.unlabeledSlider width state |>
  Collage.Render.svg |>
  List.singleton |>
  div
    [
      style
        [
          ("position", "fixed"),
          ("top", "50%"),
          ("left", "50%"),
          ("margin-left", toString (negate (width / 2)) ++ "px")
        ]
    ]
