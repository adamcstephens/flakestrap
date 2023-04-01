import shell
import config

let configData: Config = loadConfig()

let fetchFlake = &"nix flake archive --refresh {configData.flake}"
let nixosRebuild = &"sudo nixos-rebuild switch --refresh --flake {configData.flake}"

shell:
  ($fetchFlake)
  ($nixosRebuild)
