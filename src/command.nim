import config
import std/osproc
import std/logging

# run command, stream the output to the console, exit if the command fails
proc cmd*(command: string): string =
  logger.log(lvlInfo, command)

  let (output, rc) = execCmdEx(command, options = {poUsePath})
  logger.log(lvlInfo, output)

  if rc != 0:
    logger.log(lvlError, "Command failed with exit code " & $rc)
    quit(1)

  return output
