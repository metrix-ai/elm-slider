module Metrix.Slider.Maybe exposing (..)


validate : (a -> Bool) -> a -> Maybe a
validate predicate a =
  if predicate a
    then Just a
    else Nothing
