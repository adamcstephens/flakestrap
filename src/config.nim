import std/json
import std/logging
import std/options
import std/os
import std/strformat

type
  Config* = object
    flake*: string
    host*: Option[string]

let logger* = newConsoleLogger(fmtstr = "[$datetime] $levelname: ")

# Find which of three files exists
# Set the path to the first file that exists
proc findFile(file1, file2, file3: string): string =
  if fileExists(file1):
    result = file1
  elif fileExists(file2):
    result = file2
  elif fileExists(file3):
    result = file3
  else:
    logger.log(lvlError, &"Could not find flakestrap.json")
    quit(1)

  return result

# Define a proc to load a config file
proc loadConfig*(): Config =
  # Read an environment variable to the path of a file
  let configPath = getEnv("FLAKESTRAP_CONFIG_PATH", "")

  let jsonPath = findFile("/run/flakestrap.json", "/etc/flakestrap.json", &"{configPath}/flakestrap.json")

  # Read JSON data from jsonPath and catch an IOError
  var jsonString: string
  try:
    logger.log(lvlInfo, &"Reading flakestrap config from {jsonPath}")
    jsonString = readFile(jsonPath)
  except IOError:
    echo "Error: Could not read flakestrap.json"
    quit(1)

  # Parse JSON data
  let jsonData = parseJson(jsonString)

  return to(jsonData, Config)
