module Metrix.Slider.Collage exposing (..)

import Collage exposing (..)
import Collage.Layout exposing (..)
import Collage.Text exposing(..)
import Collage.Events exposing(..)
import Metrix.Slider.State exposing (State)
import Metrix.Slider.Update exposing (..)
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
      in shift (x, -30) ((textLabel index state) label)) |>
  Array.toList |>
  group

textLabel : Int -> State -> String -> Collage Update
textLabel index state label =
  let
    labelt = (String.lines label)
  in
    (List.indexedMap (lineLabel index state) (labelt) |>
    vertical) :: [spacer 77 50] |> stack |> onMouseEnter (\ _ -> (EnterLabel index)) |> onMouseLeave (\ _ -> LeaveLabel)

lineLabel : Int -> State -> Int -> String -> Collage Update
lineLabel indexDot state index str =
  let
    text =
      fromString str
      |> size 14
      |> typeface (Font "DINPro")
      |> color state.colors.inactiveLabel
      |> weight Light
  in
    let
      res =
        case state.value of
          Just position ->
            if indexDot == position then
              text |> weight Medium |> color state.colors.activeLabel
            else
              case state.hoverLable of
                Just i -> if indexDot == i then
                              text |> color state.colors.activeLabel
                            else
                              text
                _ -> text
          _ ->
            case state.hoverLable of
              Just i -> if indexDot == i then
                            text |> color state.colors.activeLabel
                          else
                            text
              _ -> text

    in
      res |> rendered |> shift (0, -20 * (toFloat index))

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
  group
  [
    (styled
      (uniform state.colors.thumb, invisible)
      (circle 12) |>
    center),
    (styled
      (uniform state.colors.outlinethumbBlur, invisible)
      (circle 12) |>
    center) |> shift (1, -1)
  ]

labeledSlider : Float -> SliderRender
labeledSlider scaleWidth state =
    case state.thumbPosition of
      Just position ->
        horizontal [
          spacer 46.625 70,
          group
            [
              thumb state |> shift (scaleWidth * position, 0),
              scale scaleWidth state
              --, labels scaleWidth state
            ]
          , spacer 46.625 70
          ]
      _ ->
        horizontal [
          spacer 46.625 70,
          group
            [
              outlined invisible (circle 12),
              scale scaleWidth state
              --, labels scaleWidth state
            ]
          , spacer 46.625 70
          ]
