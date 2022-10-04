module Money.Discrete where

import Prelude

import Data.Argonaut.Core as J
import Data.Argonaut.Decode (class DecodeJson, JsonDecodeError(..), decodeJson, getField)
import Data.Argonaut.Encode (class EncodeJson)
import Data.Either (Either(..))
import Data.Generic.Rep (class Generic)
import Data.Int (toNumber)
import Data.Newtype (class Newtype)
import Data.Symbol (class IsSymbol, reflectSymbol)
import Foreign.Object as Object
import Type.Proxy (Proxy(..))

newtype Discrete (currency :: Symbol) (unit :: Symbol) = Discrete Int

derive instance Eq (Discrete c u)
derive instance Ord (Discrete c u)
derive instance Generic (Discrete c u) _
derive instance Newtype (Discrete c u) _

derive newtype instance Semiring (Discrete c u)
derive newtype instance Ring (Discrete c u)
derive newtype instance CommutativeRing (Discrete c u)
derive newtype instance EuclideanRing (Discrete c u)

instance (IsSymbol c, IsSymbol u) => Show (Discrete c u) where
  show (Discrete r) =
    "(Discrete "
      <> (reflectSymbol (Proxy :: Proxy c))
      <> " "
      <> (reflectSymbol (Proxy :: Proxy u))
      <> " "
      <> show r
      <> ")"

instance (IsSymbol c, IsSymbol u) => EncodeJson (Discrete c u) where
  encodeJson (Discrete i) =
    J.fromObject
      ( Object.empty
          # Object.insert "currency" (J.fromString $ reflectSymbol (Proxy :: Proxy c))
          # Object.insert "unit" (J.fromString $ reflectSymbol (Proxy :: Proxy u))
          # Object.insert "amount" (J.fromNumber $ toNumber i)
      )

instance (IsSymbol c, IsSymbol u) => DecodeJson (Discrete c u) where
  decodeJson json = do
    o <- decodeJson json
    (c :: String) <- getField o "currency"
    (i :: Int) <- getField o "amount"
    (u :: String) <- getField o "unit"
    let c' = (reflectSymbol (Proxy :: Proxy c))
    let u' = (reflectSymbol (Proxy :: Proxy u))
    if (c == c' && u == u') then pure $ Discrete i
    else Left (TypeMismatch (c <> " " <> u <> " /= " <> c' <> " " <> u'))
