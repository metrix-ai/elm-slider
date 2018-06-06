module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style)
import Metrix.Slider as Slider


htmlStyleCss : Html msg
htmlStyleCss =
    node "style"
        []
        [ "@import url(\"/css/main.css?v=7\");"
            ++ "@import url(\"/fonts/DINPro.css\");"
            ++ "@import url(\"/fonts/BebasNeue.css\");"
            |> text
        ]


main : Program Never Slider.Model Slider.Msg
main =
    Html.program
        { init = Slider.init
        , view =
            \model ->
                Html.div [ style [ ( "padding", "50px" ) ] ]
                    [ Slider.view model
                    , htmlStyleCss
                    ]
        , update = Slider.update
        , subscriptions = Slider.subscriptions
        }
