{ nixpkgs ? import ./nixpkgs.nix {} }: with nixpkgs;

let 

  spagoPkgs = import ./spago-packages.nix { inherit pkgs; };

in pkgs.stdenv.mkDerivation {
  name = "my-purerl-project";
  src = ./.;
  sandbox = false;

  buildInputs = [
    spagoPkgs.installSpagoStyle
    spagoPkgs.buildSpagoStyle
  ];

  nativeBuildInputs = with pkgs; [
    erlang
    easy-purescript.purescript
  ];

  unpackPhase = ''
    cp $src/spago.dhall .
    cp $src/packages.dhall .
    cp -r $src/src .
    install-spago-style
  '';

  buildPhase = ''
    build-spago-style
  '';

  installPhase = ''
    mkdir $out
    mv output $out/
  '';

  }
