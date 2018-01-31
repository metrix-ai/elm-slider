module Metrix.Slider.Subscriptions exposing (..)

import Mouse
import Metrix.Slider.State exposing (State)
import Metrix.Slider.Update as Update exposing (Update)


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
