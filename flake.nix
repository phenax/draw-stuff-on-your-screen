{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs { inherit system; };
        libDependencies = with pkgs; [
          SDL2
          SDL2_gfx
          xorg.libX11
        ];
        shardYml = builtins.fromJSON (builtins.readFile(pkgs.runCommand "get-shards-yml" {} ''
          ${pkgs.yaml2json}/bin/yaml2json < ${./shard.yml} > $out
        ''));
      in {
        devShells.default = pkgs.mkShell rec {
          buildInputs = with pkgs; [
            just
            crystal
            shards
            crystal2nix
          ] ++ libDependencies;

          LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath buildInputs}";
        };

        packages.default = pkgs.crystal.buildCrystalPackage {
          pname = shardYml.name;
          version = shardYml.version;
          src = ./.;

          format = "shards";
          shardsFile = ./shards.nix;

          doInstallCheck = false;

          crystalBinaries.dsoys.src = shardYml.targets.dsoys.main;
          crystalBinaries.dsoys.options = ["--release" "-O=3" "--progress" "--verbose"];
          buildInputs = libDependencies;
          nativeBuildInputs = with pkgs; [ pkg-config ];
        };
      });
}
