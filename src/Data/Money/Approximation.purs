module Money.Approximation where

import Prelude

import Data.Int as Int
import Data.Ord (abs, signum)
import Data.Rational (Rational, (%))
import Data.Rational as Rat

data Approximation
  = Round
  | Floor
  | Ceiling
  | Truncate
  | HalfEven
  | HalfAwayFromZero

approximate :: Approximation -> Rational -> Int
approximate Round = Int.round <<< Rat.toNumber
approximate Floor = Int.floor <<< Rat.toNumber
approximate Ceiling = Int.ceil <<< Rat.toNumber
approximate Truncate = truncate
approximate HalfEven = halfEven
approximate HalfAwayFromZero = halfAwayFromZero

truncate :: Rational -> Int
truncate r = Int.quot (Rat.numerator r) (Rat.denominator r)

halfEven :: Rational -> Int
halfEven r = i
  where
  tr = truncate r
  rr = (Rat.fromInt tr) - r
  i
    | abs rr /= (1 % 2) = Int.round <<< Rat.toNumber $ r
    | Int.even tr = tr
    | otherwise = tr + signum tr

halfAwayFromZero :: Rational -> Int
halfAwayFromZero r = i
  where
  s = truncate (signum r)
  ar = abs r
  tr = truncate ar
  rr = ar - (Rat.fromInt tr)
  i
    | rr < (1 % 2) = s * tr
    | otherwise = s * (tr + 1)

