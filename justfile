setup:
  shards install
  crystal2nix

build:
  nix build

run:
  crystal run src/main.cr

fmt:
  crystal tool format
