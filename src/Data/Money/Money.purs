module Money where

import Prelude

import Data.Rational as Rat
import Data.Tuple (Tuple(..))
import Data.Typelevel.Num (class Pos)
import Money.Approximation (Approximation, approximate)
import Money.Dense (Dense(..))
import Money.Discrete (Discrete(..))
import Money.Scale (class UnitScale, scale)
import Type.Prelude (Proxy(..))

denseFromDiscrete
  :: forall c u m n
   . Pos m
  => Pos n
  => UnitScale c u (Tuple m n)
  => Discrete c u
  -> Dense c
denseFromDiscrete (Discrete i) =
  Dense (Rat.fromInt i / (scale (Proxy :: Proxy (Discrete c u))))

discreteFromDense
  :: forall c u m n
   . Pos m
  => Pos n
  => UnitScale c u (Tuple m n)
  => Approximation
  -> Dense c
  -> Tuple (Discrete c u) (Dense c)
discreteFromDense approx (Dense r) = Tuple d rest
  where
  s = scale (Proxy :: Proxy (Discrete c u))
  i = approximate approx (r * s)
  l = Rat.fromInt i / s
  d = Discrete i
  rest = Dense (r - l)
