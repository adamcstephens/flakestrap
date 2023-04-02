{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux"];

      perSystem = {
        config,
        pkgs,
        ...
      }: {
        devShells.default = pkgs.mkShellNoCC {
          shellHook = ''
            export FLAKESTRAP_CONFIG_PATH=$PWD/example
            export FLAKESTRAP_STATE_DIR=$PWD/example
          '';

          packages = [
            pkgs.nim
            pkgs.nimlsp
          ];
        };

        packages = rec {
          default = flakestrap;
          flakestrap = pkgs.callPackage ./nix/package.nix {};
        };
      };

      flake.nixosModules.default = import ./nix/nixos-module.nix;
    };
}
