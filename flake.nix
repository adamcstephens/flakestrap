{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
      ];
      systems = ["x86_64-linux" "aarch64-darwin"];

      perSystem = {pkgs, ...}: {
        devShells.default = pkgs.mkShellNoCC {
          shellHook = ''
            export FLAKESTRAP_CONFIG_PATH=$PWD/example
          '';

          packages = [
            pkgs.nim
            pkgs.nimlsp
          ];
        };
      };
    };
}
