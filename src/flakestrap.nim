import command
import config
import std/json
import std/options
import std/os
import std/strformat

let configData: Config = loadConfig()

let user = getEnv("USER", "nobody")
let sudo = if (user == "root"): "" else: "sudo "

let archive = cmd(&"nix flake archive --json --extra-experimental-features 'nix-command flakes' --refresh {configData.flake}")

let archiveStorePath: string = parseJson(archive)["path"].getStr()
let flakeTarget = archiveStorePath & "#" & (if configData.host.isSome(): configData.host.get() else: "")

discard cmd(&"{sudo}nixos-rebuild switch --refresh --flake {flakeTarget}")
