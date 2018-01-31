module Metrix.Slider.Update exposing (..)

import Metrix.Slider.State exposing (State)


type Update =
  DragStartedUpdate Int Int |
  DragProgressedUpdate Int |
  DragStoppedUpdate Int |
  ValueSetUpdate Int

update : Update -> State -> (State, Cmd Update)
update update state =
  case update of
    DragStartedUpdate mouse element -> Debug.crash "TODO"
    _ -> Debug.crash "TODO"
