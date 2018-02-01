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
    DragStartedUpdate mouse element -> Debug.crash ("TODO: " ++ toString (mouse, element))
    _ -> Debug.crash "TODO"
