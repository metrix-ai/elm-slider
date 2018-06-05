module Metrix.Slider.Program exposing (..)

import Array exposing (..)
import Html
import Html.Attributes as Attributes
import Metrix.Slider.Html as Html
import Metrix.Slider.State as State
import Metrix.Slider.Subscriptions as Subscriptions
import Metrix.Slider.Update as Update


type alias SliderProgram =
    Program Never State.State Update.Update


test1 : SliderProgram
test1 =
    Html.beginnerProgram
        { model = State.defaultInit
        , view = Html.view
        , update = always identity
        }


test2 : Program Never (Array State.State) Update.Update
test2 =
    Html.program
        { init = ( Array.repeat 20 State.defaultInit, Cmd.none )
        , view =
            \state ->
                Html.div
                    [ Attributes.style
                        [ ( "margin-left", "500px" )
                        , ( "margin-top", "50px" )
                        ]
                    ]
                <|
                    Array.toList <|
                        Array.map Html.view state
        , update = \msg state -> ( mapFirst (Tuple.first << Update.update msg) state, Cmd.none )
        , subscriptions = \state -> Subscriptions.all <| Maybe.withDefault State.defaultInit (Array.get 0 state)
        }


mapFirst : (a -> a) -> Array a -> Array a
mapFirst f list =
    Array.set 0 (f <| fromJust <| Array.get 0 list) list


fromJust : Maybe a -> a
fromJust a =
    case a of
        Just x ->
            x

        Nothing ->
            Debug.crash ""
