module Metrix.Slider.Maybe exposing (..)

import Maybe exposing (..)


validate : (a -> Bool) -> a -> Maybe a
validate predicate a =
  if predicate a
    then Just a
    else Nothing

isJust : Maybe a -> Bool
isJust x =
  case x of
    Just _ -> True
    Nothing -> False
