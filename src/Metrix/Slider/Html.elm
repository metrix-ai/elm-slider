module Metrix.Slider.Html
  exposing ( labeledSlider )

{-|
# Render

@docs labeledSlider
-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Collage
import Collage.Render exposing(..)
import Collage.Layout
import Metrix.Slider.State as State exposing (State)
import Metrix.Slider.Update as Update exposing (Update)
import Metrix.Slider.Collage as Collage
import Metrix.Slider.Svg.Events as SvgEvents
import Array
import Svg
import Svg.Attributes
import MouseEvents as ME
import Color.Convert exposing (colorToCssRgba)
import Color.Interpolate
import Debug

htmlStyleCss : Html msg
htmlStyleCss =
  node "style" []
  [ "@import url(\"/css/document.css\");" ++
    "@import url(\"/fonts/DINPro.css\");" ++
    "@import url(\"/fonts/BebasNeue.css\");" ++
    ".style-elements .__3402792823 {  border-style: solid;}" |> text]
{-|
Take width, instance of the slider model and render Metrix slider
-}
labeledSlider : State -> Html Update
labeledSlider state =
  div [] [(htmlSlider state
      -- SvgEvents.onMouseDownWithDetails
      --   (\ event ->
      --     Update.DragStartedUpdate
      --     (Tuple.first event.mousePosition)
      --     (Tuple.first event.elementPosition)),
    ), htmlStyleCss]


htmlSlider : State -> Html Update
htmlSlider state =
  div [
      ME.onMouseDown (\e -> Update.DragStartedUpdate e.clientPos.x e.targetPos.x),
      ME.onMouseEnter (\e -> Update.RememberElementPos e.targetPos.x)
    ] [
      div [style [("width", toString state.scaleWidth ++ "px"), ("height", "92px"), ("user-select", "none")]] [
        over [
          div [style [("padding",  "0px 40px")]] [ over <|
            case state.thumbPosition of
              Just position -> [
                thumb (state.scaleWidth * position) state,
                scale state
              ]
              _ -> [
                scale state
              ]
            ],
          labels state
        ]
      ]
    ]

thumb : Float -> State -> Html Update
thumb left state =
  circle 12 [("position", "relative"), ("left", toString left ++ "px"), ("top", "12px"), 
    ("background", colorToCssRgba state.colors.thumb), ("box-shadow", "-1px 0 2px 0 " ++ colorToCssRgba state.colors.outlinethumbBlur)]

scale : State -> Html Update
scale state =
  let 
    color = Color.Interpolate.interpolate Color.Interpolate.RGB state.colors.inactiveBar state.colors.activeBar state.activeFactor |> colorToCssRgba
  in
    div [(style [("width", toString state.scaleWidth ++ "px"),("height", "6px"),("margin", "-3px"), ("text-align", "center"),  ("position", "relative"), ("left", "0px"), ("top", "11px"), ("background", color), ("border-radius", "3px")])] [
      scaleStops state
    ]

scaleStop : State -> Html Update
scaleStop state = 
  circle 4.5 [
    ("background", colorToCssRgba state.colors.scaleStop), 
    ("box-shadow", "0 0 3px 0 " ++ colorToCssRgba state.colors.outline)
  ]

scaleStops : State -> Html Update
scaleStops state =
  scaleStop state |>
  List.repeat (Array.length state.labels) |>
  row [("width", toString state.scaleWidth ++ "px"), ("height", "6px")]

labels : State -> Html Update
labels state =
  state.labels |>
  Array.indexedMap (textLabel state) |>
  Array.toList |>
  row [("width", toString (state.scaleWidth + 80) ++ "px"), ("position", "relative"), ("left", "0px"), ("top", "15px")]



textLabel : State -> Int -> String -> Html Update
textLabel state indexDot str =
  let
    enter = ME.onMouseEnter (\_ -> Update.EnterLabel indexDot)
    leave = ME.onMouseLeave (\_ -> Update.LeaveLabel)
    default = (colorToCssRgba state.colors.inactiveLabel, "300")
    (color, weight) =
      case state.value of
        Just position ->
          if indexDot == position then
            (colorToCssRgba state.colors.activeLabel, "500")
          else
            case state.hoverLable of
              Just i -> if indexDot == i then
                            (colorToCssRgba state.colors.activeLabel, "500")
                          else
                            default
              _ -> default
        _ ->
          case state.hoverLable of
            Just i -> if indexDot == i then
                          (colorToCssRgba state.colors.activeLabel, "500")
                        else
                          default
            _ -> default
  in
    pre [enter, leave, style [("font-size", "14px"), ("text-align", "center"), ("width", "90px"), ("font-family", "DINPro"), ("color", color), ("font-weight", weight)]] [text str]

circle : Float -> List (String, String) -> Html a
circle radius extraStyle = 
  let 
    radiusPx = toString radius ++ "px"
    diametrPx = toString (radius*2) ++ "px"
  in 
    div [extraStyle ++ [
        ("width", diametrPx),
        ("height", diametrPx),
        ("border-radius", radiusPx),
        ("margin", "-" ++ radiusPx)
      ] |> style
    ] []

row : List (String, String) -> List (Html a) -> Html a
row extraStyle elems =
  div [extraStyle ++
    [
      ("display", "flex"),
      ("flex-direction", "row"),
      ("justify-content", "space-between"),
      ("align-items", "center")
    ] |> style
  ] elems

-- labeledSlider : Float ->  State -> Html Update
-- labeledSlider scaleWidth state =
--     case state.thumbPosition of
--       Just position ->
--         horizontal [
--           spacer 46.625 70,
--           group
--             [
--               thumb state |> shift (scaleWidth * position, 0),
--               scale scaleWidth state,
--               labels scaleWidth state
--             ]
--           , spacer 46.625 70
--           ]
--       _ ->
--         horizontal [
--           spacer 46.625 70,
--           group
--             [
--               outlined invisible (circle 12),
--               scale scaleWidth state,
--               labels scaleWidth state
--             ]
--           , spacer 46.625 70
--           ]

-- place elements over each other (first is top)
over : List (Html a) -> Html a
over elements = 
  let 
    insert elem inner = div [style [("position", "absolute")]] [inner, elem]
  in 
    List.foldr insert (div [] []) elements
          






----- FLEXBOX HELPERS | TODO  - create module



