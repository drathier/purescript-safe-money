module Money.Scale where

import Data.Rational (Rational, (%))
import Data.Tuple (Tuple)
import Data.Typelevel.Num (class Pos, D0, D1, D10, toInt')
import Data.Typelevel.Num.Reps (type (:*))
import Type.Prelude (Proxy(..))

class UnitScale :: forall scale. Symbol -> Symbol -> scale -> Constraint
class UnitScale (currency :: Symbol) (unit :: Symbol) scale | currency unit -> scale

scale
  :: forall c u m n f
   . Pos m
  => Pos n
  => UnitScale c u (Tuple m n)
  => Proxy (f c u)
  -> Rational
scale _ = (toInt' (Proxy :: Proxy m)) % (toInt' (Proxy :: Proxy n))

type D100 = (D10 :* D0)

instance UnitScale "SEK" "sek" (Tuple D1 D1)
instance UnitScale "SEK" "öre" (Tuple D100 D1)

instance UnitScale "USD" "usd" (Tuple D1 D1)
instance UnitScale "USD" "cent" (Tuple D100 D1)

instance UnitScale "EUR" "euro" (Tuple D1 D1)
instance UnitScale "EUR" "cent" (Tuple D100 D1)
