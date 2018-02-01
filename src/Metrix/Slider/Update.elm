module Metrix.Slider.Update exposing (..)

import Metrix.Slider.State exposing (State)


type Update =
  DragStartedUpdate Int Int |
  DragProgressedUpdate Int |
  DragStoppedUpdate Int |
  ValueSetUpdate Int

update : Update -> State -> (State, Cmd Update)
update update =
  simple <| \ state ->
    case update of
      DragStartedUpdate mouse element ->
        Debug.log (toString mouse) <|
        {state| drag = Just {element = element, mouse = mouse}}
      DragProgressedUpdate mouse ->
        Debug.log (toString mouse) <|
        {state| drag = Maybe.map (\ dragState -> {dragState| mouse = mouse}) state.drag}
      DragStoppedUpdate mouse ->
        Debug.crash "TODO"
      _ ->
        Debug.crash "TODO"

simple : (State -> State) -> State -> (State, Cmd Update)
simple newState state =
  (newState state, Cmd.none)
