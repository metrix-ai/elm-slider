module Metrix.Slider.Html exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Collage
import Collage.Render
import Collage.Layout
import Metrix.Slider.State as State exposing (State)
import Metrix.Slider.Update as Update exposing (Update)
import Metrix.Slider.Collage as Collage
import Metrix.Slider.Svg.Events as SvgEvents
import Svg
import Svg.Attributes
import Svg.Events


unlabeledSlider : Float -> State -> Html Update
unlabeledSlider width state =
  Collage.unlabeledSlider width state |>
  autosizedCollage
    [
      SvgEvents.onMouseDownWithDetails
        (\ event -> Update.DragStartedUpdate (Tuple.first event.mousePosition) (Tuple.first event.elementPosition)),
      style
        [
          ("position", "fixed"),
          ("top", "50%"),
          ("left", "50%"),
          ("margin-left", toString (negate (width / 2)) ++ "px")
        ]
    ]

autosizedCollage : List (Svg.Attribute msg) -> Collage.Collage msg -> Html msg
autosizedCollage extraAttributes collage =
  let
    width = Collage.Layout.width collage
    height = Collage.Layout.height collage
    attributes =
      [
        Svg.Attributes.width (toString width),
        Svg.Attributes.height (toString height)
      ]
  in
    collage |>
    Collage.shift (width / 2, -height / 2) |>
    Collage.Layout.align Collage.Layout.topLeft |>
    Collage.Render.svgExplicit attributes |>
    List.singleton |>
    div extraAttributes 
