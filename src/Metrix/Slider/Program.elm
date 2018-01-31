module Metrix.Slider.Program exposing (..)

import Html
import Metrix.Slider.State as State
import Metrix.Slider.Update as Update


type alias SliderProgram = Program Never State.State Update.Update

test1 : SliderProgram
test1 =
  Debug.crash "TODO"
