module Metrix.Slider.State
    exposing
        ( AnimationState
        , State
        , applyGradientAnimations
        , applyThumbPositionAnimations
        , defaultInit
        , setGradientAnimation
        , setMouseDownPosition
        , updateGradientAnimations
        , updatePositionAnimations
        )

{-|


# Definitions

@docs State, AnimationState


# Initialize

@docs defaultInit


# Service functions

@docs setMouseDownPosition, setGradientAnimation, updatePositionAnimations, applyThumbPositionAnimations, applyGradientAnimations, updateGradientAnimations

-}

import Array
import Ease
import Metrix.Slider.Colors as Colors
import Time exposing (Time)


{-| Slider model
-}
type alias State =
    { scaleXMargin : Int
    , scaleWidth : Float
    , labelFontSize : Float
    , thumbPositionAnimations : List AnimationState
    , drag : Maybe { element : Int, mouse : Int }
    , value : Maybe Int
    , thumbPosition : Maybe Float
    , activeFactor : Float
    , labelsFont : String
    , labels : Array.Array String
    , hoverLable : Maybe Int
    , colors : Colors.Colors
    , gradientAnimations : List AnimationState
    , elementPos : Int
    , active : Bool
    }


{-| Animation model
-}
type alias AnimationState =
    { start : Float
    , end : Float
    , progress : Float
    , previousProgress : Float
    , duration : Time
    }


{-| -}
setMouseDownPosition : Int -> State -> State
setMouseDownPosition mouse state =
    case state.drag of
        Just dragState ->
            let
                maxValue =
                    Array.length state.labels - 1

                scaleProgress =
                    toFloat (mouse - state.elementPos - state.scaleXMargin) / state.scaleWidth

                newValue =
                    round (scaleProgress * toFloat maxValue)
                        |> clamp 0 maxValue
            in
            case state.value of
                Just value ->
                    if newValue /= value then
                        let
                            newAnimation =
                                let
                                    max =
                                        toFloat maxValue

                                    start =
                                        toFloat value / max

                                    end =
                                        toFloat newValue / max
                                in
                                { start = start, end = end, progress = 0, previousProgress = 0, duration = Time.inMilliseconds 200 }
                        in
                        { state
                            | thumbPositionAnimations = newAnimation :: state.thumbPositionAnimations
                            , drag = Just { dragState | mouse = mouse }
                            , value = Just newValue
                        }
                    else
                        { state
                            | drag = Just { dragState | mouse = mouse }
                        }

                _ ->
                    { state | value = Just newValue, thumbPosition = Just (toFloat newValue / toFloat maxValue) }

        _ ->
            state


{-| -}
setGradientAnimation : State -> State
setGradientAnimation state =
    case state.value of
        Nothing ->
            let
                newGradientAnimations =
                    { start = 0, end = 1, progress = 0, previousProgress = 0, duration = Time.inMilliseconds 1000 }
            in
            { state | gradientAnimations = newGradientAnimations :: state.gradientAnimations }

        _ ->
            state


{-| -}
updateGradientAnimations : Time -> State -> State
updateGradientAnimations timeDiff state =
    state.gradientAnimations
        |> List.map
            (\x ->
                let
                    newProgress =
                        if x.progress < 1 then
                            min 1 (x.progress + timeDiff / x.duration)
                        else
                            x.progress + timeDiff / x.duration
                in
                { x | progress = newProgress, previousProgress = x.progress }
            )
        |> List.filter (\x -> x.progress <= 1)
        |> (\newGradientAnimations -> { state | gradientAnimations = newGradientAnimations })


{-| -}
applyGradientAnimations : State -> State
applyGradientAnimations state =
    state.gradientAnimations
        |> List.foldr interpretGradientAnimations state


interpretGradientAnimations : AnimationState -> State -> State
interpretGradientAnimations animationState state =
    let
        ease =
            Ease.outQuint

        delta =
            (animationState.end - animationState.start)
                * (ease animationState.progress - ease animationState.previousProgress)

        newActiveFactor =
            state.activeFactor + delta
    in
    { state | activeFactor = newActiveFactor }


{-| -}
updatePositionAnimations : Time -> State -> State
updatePositionAnimations timeDiff state =
    state.thumbPositionAnimations
        |> List.map
            (\x ->
                let
                    newProgress =
                        if x.progress < 1 then
                            min 1 (x.progress + timeDiff / x.duration)
                        else
                            x.progress + timeDiff / x.duration
                in
                { x | progress = newProgress, previousProgress = x.progress }
            )
        |> List.filter (\x -> x.progress <= 1)
        |> (\newAnimationStates -> { state | thumbPositionAnimations = newAnimationStates })


{-| -}
applyThumbPositionAnimations : State -> State
applyThumbPositionAnimations state =
    state.thumbPositionAnimations
        |> List.foldr interpretThumbPositionAnimation state


interpretThumbPositionAnimation : AnimationState -> State -> State
interpretThumbPositionAnimation animationState state =
    let
        ease =
            Ease.inOutQuart

        delta =
            (animationState.end - animationState.start)
                * (ease animationState.progress - ease animationState.previousProgress)

        newThumbPosition =
            case state.thumbPosition of
                Just position ->
                    position + delta

                _ ->
                    animationState.end
    in
    { state | thumbPosition = Just newThumbPosition }


{-| Init default slider
-}
defaultInit : State
defaultInit =
    { scaleXMargin = 40
    , scaleWidth = 518
    , thumbPositionAnimations = []
    , drag = Nothing
    , value = Nothing
    , thumbPosition = Nothing
    , activeFactor = 0
    , labelFontSize = 14
    , labelsFont = "Arial"
    , labels = Array.fromList [ "Полностью \nне согласен", "Скорее \nне согласен", "Затрудняюсь \nответить", "Скорее \nсогласен", "Полностью \nсогласен" ]
    , colors = Colors.metrix
    , hoverLable = Nothing
    , gradientAnimations = []
    , elementPos = 0
    , active = False
    }
