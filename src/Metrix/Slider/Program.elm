module Metrix.Slider.Program exposing (..)

import Html
import Metrix.Slider.State as State
import Metrix.Slider.Update as Update
import Metrix.Slider.Html as Html


type alias SliderProgram = Program Never State.State Update.Update

test1 : SliderProgram
test1 =
  Html.beginnerProgram
    {
      model = State.selectedTest,
      view = Html.unlabeledSlider 518,
      update = always identity
    }
