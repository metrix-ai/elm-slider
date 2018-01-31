module Metrix.Slider.Collage exposing (..)

import Collage exposing (..)
import Collage.Layout exposing (..)
import Metrix.Slider.State exposing (State)
import Metrix.Slider.Update exposing (Update)
import Metrix.Slider.Maybe as Maybe
import Color.Interpolate
import Array


type alias SliderRender = State -> Collage Update

scale : Float -> SliderRender
scale scaleWidth state =
  group
    [
      scaleStops scaleWidth state,
      scaleBar scaleWidth state
    ]

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
      scale scaleWidth state
    ]
