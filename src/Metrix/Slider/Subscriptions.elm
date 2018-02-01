module Metrix.Slider.Subscriptions exposing (..)

import Sub exposing (..)
import Mouse
import Metrix.Slider.State exposing (State)
import Metrix.Slider.Update as Update exposing (Update)
import AnimationFrame


drag : State -> Sub Update
drag state =
  case state.drag of
    Nothing -> Sub.none
    Just _ ->
      Sub.batch
        [
          Mouse.moves (.x >> Update.DragProgressedUpdate),
          Mouse.ups (.x >> Update.DragStoppedUpdate)
        ]

animation : State -> Sub Update
animation state =
  if List.isEmpty state.animations
    then Sub.none
    else AnimationFrame.diffs Update.TimeDiffUpdate

all : State -> Sub Update
all state =
  batch
    [
      drag state,
      animation state
    ]
