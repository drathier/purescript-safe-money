{ name = "purescript-safe-money"
, dependencies =
  [ "argonaut-codecs"
  , "argonaut-core"
  , "console"
  , "effect"
  , "either"
  , "foreign-object"
  , "integers"
  , "newtype"
  , "prelude"
  , "rationals"
  , "tuples"
  , "typelevel"
  , "typelevel-prelude"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
