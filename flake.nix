{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
    in
    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs { inherit system; };
        libDependencies = with pkgs; [
          SDL2
          SDL2_gfx
          xorg.libX11
        ];
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            just
            crystal
            shards
            # crystal2nix
          ] ++ libDependencies;
        };
      });
}
