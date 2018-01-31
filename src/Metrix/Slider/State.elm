module Metrix.Slider.State exposing (..)

import Array


type alias State =
  {
    value : Maybe Int,
    thumbPosition : Maybe Float,
    width : Float,
    height : Float,
    labelsFont : String,
    labels : Array.Array String
  }

setValue : Maybe Int -> State -> State
setValue value state =
  {state|
    value = value,
    thumbPosition =
      Maybe.map
        (\ existingValue -> toFloat existingValue / toFloat (Array.length state.labels))
        value
  }

selectedTest : State
selectedTest =
  {
    value = Just 4,
    thumbPosition = Just 0.75,
    width = 680,
    height = 100,
    labelsFont = "Arial",
    labels = Array.fromList ["Полностью не согласен", "Скорее не согласен", "Затрудняюсь ответить", "Скорее согласен", "Полностью не согласен"]
  }
