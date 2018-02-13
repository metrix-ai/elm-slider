module Metrix.Slider.Update
    exposing
        ( Update(..)
        , update
        )
{-|
# Definitions

@docs Update

# Update function

@docs update
-}
import Metrix.Slider.State as State exposing (State)
import Time exposing (Time)

{-|
Message type
-}
type Update =
  DragStartedUpdate Int Int |
  DragProgressedUpdate Int |
  DragStoppedUpdate Int |
  TimeDiffUpdate Time |
  ValueSetUpdate Int |
  EnterLabel Int |
  LeaveLabel |
  GradientUpdate Time

{-|
update function
-}
update : Update -> State -> (State, Cmd Update)
update update =
    case update of
      DragStartedUpdate mouse element ->
        simple <| \ state ->
          {state| drag = Just {element = element, mouse = mouse}} |>
          State.setGradientAnimation |> State.setMouseDownPosition mouse
      DragProgressedUpdate mouse -> simple (State.setMouseDownPosition mouse)
      DragStoppedUpdate mouse ->
        simple <| \ state ->
          {state| drag = Nothing}
      TimeDiffUpdate time ->
        simple <| State.updatePositionAnimations time >> State.applyThumbPositionAnimations
      EnterLabel index -> simple <| \state -> {state| hoverLable = Just index}
      LeaveLabel -> simple <| \state -> {state| hoverLable = Nothing}
      GradientUpdate time -> simple <| State.updateGradientAnimations time >> State.applyGradientAnimations
      _ ->
        Debug.crash "TODO"

simple : (State -> State) -> State -> (State, Cmd Update)
simple newState state =
  (newState state, Cmd.none)
