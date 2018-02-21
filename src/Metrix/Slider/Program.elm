module Metrix.Slider.Program exposing (..)

import Html
import Html.Attributes as Attributes
import Metrix.Slider.State as State
import Metrix.Slider.Update as Update
import Metrix.Slider.Html as Html
import Metrix.Slider.Subscriptions as Subscriptions
import Array exposing (..)


type alias SliderProgram = Program Never State.State Update.Update

test1 : SliderProgram
test1 =
  Html.beginnerProgram
    {
      model = State.defaultInit,
      view = Html.labeledSlider,
      update = always identity
    }

test2 : Program Never (Array State.State) Update.Update
test2 =
  Html.program
    {
      init = (Array.repeat 20 State.defaultInit, Cmd.none),
      view = \state -> Html.div [
          Attributes.style [
            ("margin-left", "500px"),
            ("margin-top", "50px")
          ]
        ] <| Array.toList <| Array.map (Html.labeledSlider) state,
      update = \msg state -> (mapFirst (Tuple.first << Update.update msg) state, Cmd.none) ,
      --subscriptions = \state -> Sub.batch <| List.map Subscriptions.all state
      subscriptions = \state ->  Subscriptions.all <| Maybe.withDefault State.defaultInit (Array.get 0  state)
    }
    --subscriptions = \state ->  Subscriptions.all <| Maybe.withDefault State.defaultInit (List.head  state)

mapFirst : (a -> a) -> Array a -> Array a
mapFirst f list = Array.set 0 (f <| fromJust <| Array.get 0 list) list
  -- case list of
  --   []      -> []
  --   x :: xs -> f x :: xs
fromJust : Maybe a -> a
fromJust a = 
  case a of
    Just x -> x
    Nothing -> Debug.crash ""
        