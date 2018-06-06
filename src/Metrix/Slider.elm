module Metrix.Slider exposing (..)

import Array exposing (Array)
import DOM exposing (Rectangle)
import Html exposing (..)
import Html.Attributes exposing (class, classList, style)
import Html.Events exposing (on)
import Json.Decode as Json exposing (Decoder)
import Metrix.Slider.Internal.Decoder exposing (decodeGeometry)
import Mouse


type alias Model =
    { labels : Array String
    , active : Bool
    , initiated : Bool
    , value : Maybe Int
    , rect : Rectangle
    }


type Msg
    = OnMouseDown { pageX : Float, rect : Rectangle }
    | MouseMove Int
    | MouseUp


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


defaultModel : Model
defaultModel =
    init |> Tuple.first


init : ( Model, Cmd Msg )
init =
    { labels = Array.fromList [ "Полностью \nне согласен", "Скорее \nне согласен", "Затрудняюсь \nответить", "Скорее \nсогласен", "Полностью \nсогласен" ]
    , active = False
    , initiated = False
    , rect = { top = 0, left = 0, width = 0, height = 0 }
    , value = Nothing
    }
        ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MouseUp ->
            { model | active = False } ! []

        MouseMove pageX ->
            let
                newValue =
                    valueFromPageX model.rect (toFloat pageX) model.labels
            in
            { model | value = Just newValue } ! []

        OnMouseDown { pageX, rect } ->
            let
                newValue =
                    valueFromPageX rect pageX model.labels

                newModel =
                    { model
                        | value = Just newValue
                        , rect = rect
                        , active = True
                        , initiated = True
                    }
            in
            newModel ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.active then
        Sub.batch
            [ Mouse.moves (\{ x, y } -> MouseMove x)
            , Mouse.ups (\_ -> MouseUp)
            ]
    else
        Sub.none


valueFromPageX : Rectangle -> Float -> Array String -> Int
valueFromPageX rect pageX labels =
    let
        min =
            0.0

        max =
            Array.length labels |> flip (-) 1 |> toFloat

        xPos =
            pageX - rect.left

        pctComplete =
            xPos / rect.width
    in
    round <| clamp min max <| min + pctComplete * (max - min)


view : Model -> Html Msg
view model =
    let
        labelView index label =
            let
                active =
                    case model.value of
                        Just value ->
                            if value == index then
                                True
                            else
                                False

                        _ ->
                            False
            in
            pre [ classList [ ( "label--active", active ) ] ] [ text label ]

        labelsLength =
            Array.length model.labels

        labels =
            Array.indexedMap labelView model.labels |> Array.toList

        markers =
            List.repeat labelsLength (div [ class "slider-track-marker" ] [])

        onClick =
            on "mousedown" (Json.map OnMouseDown decodeGeometry)

        translateX =
            case model.value of
                Nothing ->
                    0.0

                Just av ->
                    (model.rect.width / toFloat (labelsLength - 1)) * toFloat av
    in
    div []
        [ div
            [ classList
                [ ( "slider-wrapper", True )
                , ( "slider-wrapper--active"
                  , model.initiated
                  )
                ]
            , onClick
            ]
            [ div [ class "slider-line" ]
                [ div [ class "slider-track-marker-wrapper" ] markers
                , div
                    [ class "slider-pointer"
                    , style
                        [ ( "transform"
                          , "translateX(-50%) translateY(-50%) translateX("
                                ++ toString translateX
                                ++ "px)"
                          )
                        ]
                    ]
                    []
                ]
            , div [ class "labels-wrapper" ] labels
            ]
        ]
