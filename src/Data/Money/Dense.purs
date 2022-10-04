module Money.Dense where

import Prelude

import Data.Argonaut.Core as J
import Data.Argonaut.Decode (class DecodeJson, JsonDecodeError(..), decodeJson, getField)
import Data.Argonaut.Encode (class EncodeJson)
import Data.Either (Either(..))
import Data.Generic.Rep (class Generic)
import Data.Int (toNumber)
import Data.Newtype (class Newtype)
import Data.Ratio (denominator, numerator)
import Data.Rational (Rational, (%))
import Data.Symbol (class IsSymbol, reflectSymbol)
import Foreign.Object as Object
import Type.Proxy (Proxy(..))

newtype Dense (currency :: Symbol) = Dense Rational

derive instance Eq (Dense c)
derive instance Ord (Dense c)
derive instance Generic (Dense c) _
derive instance Newtype (Dense c) _

derive newtype instance Semiring (Dense c)
derive newtype instance Ring (Dense c)
derive newtype instance CommutativeRing (Dense c)
derive newtype instance EuclideanRing (Dense c)

instance (IsSymbol c) => Show (Dense c) where
  show (Dense r) =
    "(Dense "
      <> (reflectSymbol (Proxy :: Proxy c))
      <> " "
      <> show r
      <> ")"

instance (IsSymbol c) => EncodeJson (Dense c) where
  encodeJson (Dense r) =
    J.fromObject
      ( Object.empty
          # Object.insert "currency" (J.fromString $ reflectSymbol (Proxy :: Proxy c))
          # Object.insert "numerator" (J.fromNumber <<< toNumber $ numerator r)
          # Object.insert "denominator" (J.fromNumber <<< toNumber $ denominator r)
      )

instance (IsSymbol c) => DecodeJson (Dense c) where
  decodeJson json = do
    o <- decodeJson json
    (c :: String) <- getField o "currency"
    (q :: Int) <- getField o "numerator"
    (p :: Int) <- getField o "denominator"
    let c' = (reflectSymbol (Proxy :: Proxy c))
    if c == c' then pure $ Dense (q % p)
    else Left (TypeMismatch (c <> " /= " <> c'))
