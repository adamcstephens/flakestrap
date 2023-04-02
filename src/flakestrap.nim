import command
import config
import std/os
import std/strformat

let configData: Config = loadConfig()

let user = getEnv("USER", "nobody")
let sudo = if (user == "root"): "" else: "sudo "

cmd(&"nix flake archive --refresh {configData.flake}")
cmd(&"{sudo}nixos-rebuild switch --refresh --flake {configData.flake}")
