module Metrix.Slider.Colors exposing (..)

import Color exposing (..)


type alias Colors =
  {
    activeBar : Color,
    inactiveBar : Color,
    thumb : Color,
    scaleStop : Color,
    outline : Color,
    outlinethumb : Color,
    outlinethumbBlur : Color,
    activeLabel : Color,
    inactiveLabel : Color
  }

metrix : Colors
metrix =
  let
    lightishGreen = rgb 96 222 129
    dusk = rgb 92 73 110
    steel = rgb 119 126 145
    duckEggBlue = rgb 244 246 253
    greyishBrown = rgb 74 74 74
    brownishGrey = rgb 92 92 92
    white = Color.white
    black = rgb 29 29 27
    veryLightBlue = rgb 229 236 255
    darkSkyBlue = rgb 74 144 226
    outLineGrey = rgba 78 75 75 0.69
    outLineGreyThumb = rgba 78 75 75 0.4
    outLineGreyThumbBlur = rgba 78 75 75 0.4
  in
    {
      activeBar = darkSkyBlue,
      inactiveBar = outLineGrey,
      thumb = darkSkyBlue,
      scaleStop = white,
      outline = outLineGreyThumb,
      outlinethumb = outLineGreyThumb,
      outlinethumbBlur = outLineGreyThumbBlur,
      activeLabel = darkSkyBlue,
      inactiveLabel = greyishBrown
    }
