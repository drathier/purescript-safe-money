module Test.Main where

import Prelude

import Data.Argonaut.Core (stringify)
import Data.Argonaut.Decode (JsonDecodeError, decodeJson)
import Data.Argonaut.Encode (encodeJson)
import Data.Either (Either)
import Data.Newtype (wrap)
import Data.Rational ((%))
import Data.Tuple (Tuple, fst)
import Effect (Effect)
import Effect.Class.Console (log, logShow)
import Money (denseFromDiscrete, discreteFromDense)
import Money.Approximation (Approximation(..))
import Money.Dense (Dense)
import Money.Discrete (Discrete)
import Money.ExchangeRate (ExchangeRate, exchange)
import Money.Scale (scale)
import Type.Prelude (Proxy(..))

-- TODO : )

main :: Effect Unit
main =
  do
    let sek = (wrap (360 % 1)) :: Dense "SEK"

    let _ = sek - (sek / (wrap (2 % 1)))

    let jsonsek = encodeJson sek
    log "Encoded Dense SEK:"
    log <<< stringify $ jsonsek

    log ""
    log "Decoded Dense SEK:"
    logShow $ ((decodeJson jsonsek) :: Either JsonDecodeError (Dense "SEK"))

    let sekd = fst (discreteFromDense Round sek) :: Discrete "SEK" "öre"
    let jsonsekd = encodeJson sekd
    log "Encoded Discrete SEK:"
    log <<< stringify $ jsonsekd

    log ""
    log "Decoded Discrete SEK:"
    logShow $ ((decodeJson jsonsekd) :: Either JsonDecodeError (Discrete "SEK" "öre"))

    let sek2eur = wrap (19 % 200) :: ExchangeRate "SEK" "EUR"
    let eur2usd = wrap (57 % 50) :: ExchangeRate "EUR" "USD"

    log ""
    log "With ExchangeRate:"
    logShow $ sek2eur >>> eur2usd

    log ""
    log $ "Given some SEK: " <> show sek <> " " <> show sekd
    let usd = exchange (sek2eur >>> eur2usd) sek
    let usdd = fst (discreteFromDense Round usd) :: Discrete "USD" "cent"
    log $ "Exchange it to USD: " <> show usd <> " " <> show usdd
    log ""

    logShow $ (fst (discreteFromDense Round usd) :: Discrete "USD" "cent")
    logShow $ denseFromDiscrete (wrap 200 :: Discrete "USD" "cent")

    log ""
    log "Scale for USD cent:"
    logShow $ scale (Proxy :: Proxy (Discrete "USD" "cent"))

    log ""

    logShow $
      ( (discreteFromDense Round (wrap (15 % 10)))
          :: Tuple (Discrete "SEK" "sek") (Dense "SEK")
      )

    logShow $
      ( (discreteFromDense Round (wrap (15 % 10)))
          :: Tuple (Discrete "SEK" "öre") (Dense "SEK")
      )
