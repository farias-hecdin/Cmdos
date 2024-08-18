import std/[os, strutils]
import pkg/tinyre
import types, utils, text_styled

proc validateCmdosCmd(cmd: CmdosCmd): bool =
  var namesCount = 0
  for opt in cmd.opts:
    if opt.names == cmd.names:
      namesCount += 1
      if namesCount > 1:
        return false
  return true

#-- Process input options
let defaultArgs: seq[string] = os.commandLineParams()

proc processArgs*(cmd: static CmdosCmd, ignoreFirstArg: bool = false, inputs: seq[string] = defaultArgs): CmdosData =
  # Validate the command
  when not validateCmdosCmd(cmd):
    errorText("There is an error in '$#'" % [cmd.names])

  let startIndex = if ignoreFirstArg: 1 else: 0
  let reExclude = tinyre.re"^-"

  for opt in cmd.opts:
    let optNames = opt.names
    let optName = getLongestWord(optNames)
    var optFound, hasValue = false
    var optValues: seq[string]

    # Validate the number of inputs for the option
    if opt.inputs.len == 0:
      errorText("The number of inputs provided in '$#' is invalid." % [optName])

    # Iterate over the input arguments
    for i in startIndex..<inputs.len:
      if inputs[i] in optNames:
        var j = (i + 1)
        optFound = true
        optValues.add(optName)
        # If the options receives one or more inputs
        while j < inputs.len and not tinyre.contains(inputs[j], reExclude):
          hasValue = true
          optValues.add(inputs[j])
          inc(j)
        # if the options no has inputs
        if hasValue == false:
          optFound = false
          optValues.setLen(optValues.len - 1)
        break
    # If no options is provided, default values will be used
    if not optFound:
      optValues.add(optName)
      optValues.add(opt.inputs)
    result.add((data: optValues))
