import config
import std/osproc

# run command, stream the output to the console, exit if the command fails
proc cmd*(command: string): string =
  echo command

  let (output, rc) = execCmdEx(command, options = {poUsePath})
  echo output

  if rc != 0:
    stderr.writeLine "Command failed with exit code " & $rc
    quit(1)

  return output
