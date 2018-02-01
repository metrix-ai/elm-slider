module Metrix.Slider.Program exposing (..)

import Html
import Metrix.Slider.State as State
import Metrix.Slider.Update as Update
import Metrix.Slider.Html as Html
import Metrix.Slider.Subscriptions as Subscriptions


type alias SliderProgram = Program Never State.State Update.Update

test1 : SliderProgram
test1 =
  Html.beginnerProgram
    {
      model = State.selectedTest,
      view = Html.unlabeledSlider 518,
      update = always identity
    }

test2 : SliderProgram
test2 =
  Html.program
    {
      init = (State.selectedTest, Cmd.none),
      view = Html.unlabeledSlider 518,
      update = Update.update,
      subscriptions = Subscriptions.all
    }
