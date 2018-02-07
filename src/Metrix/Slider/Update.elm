module Metrix.Slider.Update exposing (..)

import Metrix.Slider.State as State exposing (State)
import Time exposing (Time)


type Update =
  DragStartedUpdate Int Int |
  DragProgressedUpdate Int |
  DragStoppedUpdate Int |
  TimeDiffUpdate Time |
  ValueSetUpdate Int |
  EnterLabel Int |
  LeaveLabel

update : Update -> State -> (State, Cmd Update)
update update =
    case update of
      DragStartedUpdate mouse element ->
        simple <| \ state ->
          {state| drag = Just {element = element, mouse = mouse}} |>
          State.setMouseDownPosition mouse
      DragProgressedUpdate mouse -> simple (State.setMouseDownPosition mouse)
      DragStoppedUpdate mouse ->
        simple <| \ state ->
          {state| drag = Nothing}
      TimeDiffUpdate time ->
        simple <| State.updatePositionAnimations time >> State.applyThumbPositionAnimations
      EnterLabel index -> simple <| \state -> {state| hoverLable = Just index}
      LeaveLabel -> simple <| \state -> {state| hoverLable = Nothing}
      _ ->
        Debug.crash "TODO"

simple : (State -> State) -> State -> (State, Cmd Update)
simple newState state =
  (newState state, Cmd.none)
