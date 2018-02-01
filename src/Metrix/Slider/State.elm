module Metrix.Slider.State exposing (..)

import Array
import Metrix.Slider.Colors as Colors
import Time exposing (Time)


type alias State =
  {
    scaleXOffset : Int,
    scaleWidth : Int,
    thumbPositionAnimations : List AnimationState,
    drag : Maybe { element : Int, mouse : Int },
    value : Maybe Int,
    thumbPosition : Float,
    activeFactor : Float,
    labelsFont : String,
    labels : Array.Array String,
    colors : Colors.Colors
  }

type alias AnimationState =
  {
    start : Float,
    end : Float,
    progress : Float,
    duration : Time
  }

setMouseDownPosition : Int -> State -> State
setMouseDownPosition mouse state =
  case state.value of
    Just value ->
      case state.drag of
        Just dragState ->
          let
            scaleProgress = toFloat (mouse - dragState.element - state.scaleXOffset) / toFloat state.scaleWidth
            newValue = round (scaleProgress * toFloat (Array.length state.labels))
          in
            if newValue /= value
              then
                let
                  newAnimation =
                    let
                      length = toFloat (Array.length state.labels)
                      start = toFloat value / length
                      end = toFloat newValue / length
                    in { start = start, end = end, progress = 0, duration = Time.inMilliseconds 200 }
                in
                  {state|
                    thumbPositionAnimations = newAnimation :: state.thumbPositionAnimations,
                    drag = Just {dragState| mouse = mouse},
                    value = Just newValue
                  }
              else
                {state|
                  drag = Just {dragState| mouse = mouse}
                }
        _ -> Debug.crash "TODO"
    _ -> Debug.crash "TODO"

updatePositionAnimations : Time -> State -> State
updatePositionAnimations timeDiff state =
  state.thumbPositionAnimations |>
  List.map (\ x -> {x| progress = x.progress + timeDiff / x.duration}) |>
  List.filter (\ x -> x.progress <= 1) |>
  \ newAnimationStates -> {state| thumbPositionAnimations = newAnimationStates}

applyThumbPositionAnimations : Time -> State -> State
applyThumbPositionAnimations timeDiff state =
  state.thumbPositionAnimations |>
  List.foldr (interpretThumbPositionAnimation timeDiff) state

interpretThumbPositionAnimation : Time -> AnimationState -> State -> State
interpretThumbPositionAnimation timeDiff animationState state =
  let
    delta = (animationState.end - animationState.start) * animationState.progress / toFloat (Array.length state.labels)
  in 
  {state| thumbPosition = state.thumbPosition + delta}

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
    scaleXOffset = 0,
    scaleWidth = 518,
    thumbPositionAnimations = [],
    drag = Nothing,
    value = Just 4,
    thumbPosition = 0.75,
    activeFactor = 1,
    labelsFont = "Arial",
    labels = Array.fromList ["Полностью не согласен", "Скорее не согласен", "Затрудняюсь ответить", "Скорее согласен", "Полностью не согласен"],
    colors = Colors.metrix
  }
