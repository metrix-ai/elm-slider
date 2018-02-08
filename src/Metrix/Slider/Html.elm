module Metrix.Slider.Html
  exposing ( labeledSlider )

{-|
# Render

@docs labeledSlider
-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Collage
import Collage.Render exposing(..)
import Collage.Layout
import Metrix.Slider.State as State exposing (State)
import Metrix.Slider.Update as Update exposing (Update)
import Metrix.Slider.Collage as Collage
import Metrix.Slider.Svg.Events as SvgEvents
import Svg
import Svg.Attributes

htmlStyleCss : Html msg
htmlStyleCss =
  node "style" []
  [ "@import url(\"/css/document.css\");" ++
    "@import url(\"/fonts/DINPro.css\");" ++
    "@import url(\"/fonts/BebasNeue.css\");" ++
    ".style-elements .__3402792823 {  border-style: solid;}" |> text]
{-|
Take width, instance of the slider model and render Metrix slider
-}
labeledSlider : Float -> State -> Html Update
labeledSlider width state =
  div [] [(Collage.labeledSlider width state |>
  autosizedCollage state
    [
      SvgEvents.onMouseDownWithDetails
        (\ event ->
          Update.DragStartedUpdate
          (Tuple.first event.mousePosition)
          (Tuple.first event.elementPosition)),
      style
        [
          ("position", "fixed"),
          ("top", "50%"),
          ("left", "50%"),
          ("margin-left", toString (negate (width / 2)) ++ "px"),
          ("user-select", "none")
        ]
    ]), htmlStyleCss]

autosizedCollage : State -> List (Svg.Attribute msg) -> Collage.Collage msg -> Html msg
autosizedCollage state extraAttributes collage =
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
