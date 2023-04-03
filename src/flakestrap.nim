import command
import config
import std/json
import std/options
import std/os
import std/strformat

let configData: Config = loadConfig()

let user = getEnv("USER", "nobody")
let sudo = if (user == "root"): "" else: "sudo "
let stateDir = getEnv("FLAKESTRAP_STATE_DIR", "/var/lib/flakestrap")
let stateFile = stateDir & "/complete"

let once = if configData.once.isSome(): configData.once.get() else: false

if once and fileExists(stateFile):
  echo "Once flag set and completion file exists, exiting."
  quit(0)

let archive = cmd(&"nix flake archive --json --extra-experimental-features 'nix-command flakes' --refresh {configData.flake}")

let archiveStorePath: string = parseJson(archive)["path"].getStr()
let flakeTarget = archiveStorePath & "#" & (if configData.host.isSome(): configData.host.get() else: "")

discard cmd(&"{sudo}nixos-rebuild switch --refresh --flake {flakeTarget}")

if once:
  echo "Once flag set, writing completion file."
  discard existsOrCreateDir(stateDir)

  writeFile(stateFile, "")
