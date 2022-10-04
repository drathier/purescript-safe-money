{ nixpkgs ? import ./nixpkgs.nix {} }: with nixpkgs;

pkgs.mkShell {
  buildInputs = with pkgs; [
    easy-purescript.purescript
    easy-purescript.purescript-language-server
    easy-purescript.purs-tidy
    easy-purescript.spago
    easy-purescript.spago2nix
  ];
}
