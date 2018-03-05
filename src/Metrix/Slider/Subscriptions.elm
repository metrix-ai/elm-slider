module Metrix.Slider.Subscriptions
    exposing (all)


{-|
# Subscriptions function

@docs all
-}
import Platform.Sub exposing (..)
import Mouse
import Metrix.Slider.State exposing (State)
import Metrix.Slider.Update as Update exposing (Update)
import AnimationFrame


drag : State -> Sub Update
drag state =
  case state.drag of
    Nothing -> none
    Just _ ->
          Mouse.moves (.x >> Update.DragProgressedUpdate)

animation : State -> Sub Update
animation state =
  if List.isEmpty state.thumbPositionAnimations
    then none
    else AnimationFrame.diffs Update.TimeDiffUpdate

gradient : State -> Sub Update
gradient state =
  if List.isEmpty state.gradientAnimations
    then none
    else AnimationFrame.diffs Update.GradientUpdate

{-|
Sub
-}
all : State -> Sub Update
all state =
  batch
    [
      drag state,
      animation state,
      gradient state
    ]
