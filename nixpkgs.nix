let

  easy-purescript =
    import (builtins.fetchTarball "https://github.com/justinwoo/easy-purescript-nix/tarball/master") {};

in

{ pkgs ? import <nixpkgs> {} }:

{
  pkgs = pkgs;
  easy-purescript = easy-purescript;
}
