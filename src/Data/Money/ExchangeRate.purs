module Money.ExchangeRate where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Newtype (class Newtype)
import Data.Rational (Rational)
import Data.Symbol (class IsSymbol, reflectSymbol)
import Money.Dense (Dense(..))
import Type.Proxy (Proxy(..))

newtype ExchangeRate (src :: Symbol) (dst :: Symbol) = ExchangeRate Rational

derive instance Eq (ExchangeRate src dst)
derive instance Ord (ExchangeRate src dst)
derive instance Generic (ExchangeRate src dst) _
derive instance Newtype (ExchangeRate src dst) _

derive newtype instance Semiring (ExchangeRate src dst)
derive newtype instance Ring (ExchangeRate src dst)
derive newtype instance CommutativeRing (ExchangeRate src dst)
derive newtype instance EuclideanRing (ExchangeRate src dst)

instance Semigroupoid ExchangeRate where
  compose (ExchangeRate a) (ExchangeRate b) = ExchangeRate (a * b)

instance Category (ExchangeRate) where
  identity = one

instance (IsSymbol src, IsSymbol dst) => Show (ExchangeRate src dst) where
  show (ExchangeRate r) =
    "(ExchangeRate "
      <> (reflectSymbol (Proxy :: Proxy src))
      <> " -> "
      <> (reflectSymbol (Proxy :: Proxy dst))
      <> " "
      <> show r
      <> ")"

exchange :: forall src dst. ExchangeRate src dst -> Dense src -> Dense dst
exchange (ExchangeRate r) (Dense s) = Dense (r * s)
