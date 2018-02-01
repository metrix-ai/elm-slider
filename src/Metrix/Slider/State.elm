module Metrix.Slider.State exposing (..)

import Array
import Metrix.Slider.Colors as Colors


type alias State =
  {
    drag : Maybe { element : Int, mouse : Int },
    value : Maybe Int,
    thumbPosition : Float,
    activeFactor : Float,
    labelsFont : String,
    labels : Array.Array String,
    colors : Colors.Colors
  }

setValue : Maybe Int -> State -> State
setValue value state =
  {state|
    value = value,
    thumbPosition =
      value |>
      Maybe.map
        (\ existingValue -> toFloat existingValue / toFloat (Array.length state.labels)) |>
      Maybe.withDefault 0.5
  }

selectedTest : State
selectedTest =
  {
    drag = Nothing,
    value = Just 4,
    thumbPosition = 0.75,
    activeFactor = 1,
    labelsFont = "Arial",
    labels = Array.fromList ["Полностью не согласен", "Скорее не согласен", "Затрудняюсь ответить", "Скорее согласен", "Полностью не согласен"],
    colors = Colors.metrix
  }
