module Metrix.Slider.Collage exposing (..)

import Collage exposing (..)
import Collage.Layout exposing (..)
import Collage.Text exposing(..)
import Color exposing(..)
import Metrix.Slider.State exposing (State)
import Metrix.Slider.Update exposing (Update)
import Color.Interpolate
import Array
import String


type alias SliderRender = State -> Collage Update

scale : Float -> SliderRender
scale scaleWidth state =
  group
    [
      scaleStops scaleWidth state,
      scaleBar scaleWidth state
    ]

labels : Float -> SliderRender
labels scaleWidth state =
  state.labels |>
  Array.indexedMap
    (\ index label ->
      let
        x = (scaleWidth / toFloat (Array.length state.labels - 1)) * toFloat index
      in shift (x, -30) (name "ooo" ((textLabel index state) label))) |>
  Array.toList |>
  group

textLabel : Int -> State -> String -> Collage Update
textLabel index state label =
  let
    labelt = (String.lines label)
  in
    List.indexedMap (lineLabel index state.thumbPosition) labelt |>
    group

lineLabel : Int -> Float -> Int -> String -> Collage Update
lineLabel index1 thumbPosition index str =
  let
    x = index1 * 25
    text =
      fromString str
      |> size normal
      |> typeface (Font "DINPro")
      |> color (Color.rgb 74 74 74)
  in
    let
      res =
        if x == (round (thumbPosition * 100)) then
          text |> weight Medium
        else
          text |> weight Light
    in
      res |> rendered |> shift (0, -20 * (toFloat index)) |> name "lll"

scaleBar : Float -> SliderRender
scaleBar scaleWidth state =
  filled
    (uniform
      (Color.Interpolate.interpolate Color.Interpolate.RGB
        state.colors.inactiveBar state.colors.activeBar state.activeFactor))
    (roundedRectangle scaleWidth 6 3) |>
  align left

scaleStop : SliderRender
scaleStop state =
    styled
      (uniform state.colors.scaleStop, solid 0.5 (uniform state.colors.outline))
      (circle 4.5) |>
    center


scaleStops : Float -> SliderRender
scaleStops scaleWidth state =
  scaleStop state |>
  List.repeat (Array.length state.labels) |>
  List.indexedMap
    (\ index stop ->
      let
        x = (scaleWidth / toFloat (Array.length state.labels - 1)) * toFloat index
        label = Array.get index state.labels
      in shift (x, 0) stop) |>
  group

thumb : SliderRender
thumb state =
  filled
    (uniform state.colors.thumb)
    (circle 12) |>
  center

unlabeledSlider : Float -> SliderRender
unlabeledSlider scaleWidth state =
  group
    [
      thumb state |> shift (scaleWidth * state.thumbPosition, 0),
      scale scaleWidth state,
      labels scaleWidth state
    ]
