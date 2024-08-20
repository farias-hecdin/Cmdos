import std/[os, strutils], pkg/tinyre
import types, utils, text_styled

proc validateCmdosCmd(cmd: CmdosCmd): bool =
  var namesCount = 0
  for opt in cmd.opts:
    if opt.names == cmd.names:
      namesCount += 1
      if namesCount > 1: return false
  return true

#-- Process input options
let defaultArgs: seq[string] = os.commandLineParams()

proc processCmd*(cmd: static CmdosCmd, ignoreFirst: bool = false, inputs: seq[string] = defaultArgs): (CmdosFlags, CmdosArgs) =
  # Validate the command
  when not validateCmdosCmd(cmd):
    errorText("There is an error in '$#'" % [cmd.names])

  let startIndex = if ignoreFirst: 1 else: 0
  let reExclude = tinyre.re"^-"
  var flags: CmdosFlags = @[]
  var data: CmdosArgs = @[]

  for opt in cmd.opts:
    let optName = getLongestWord(opt.names)
    var optFound, hasValue = false
    var optValues: seq[string]

    # Iterate over the input arguments
    for i in startIndex..<inputs.len:
      if inputs[i] in opt.names:
        var j = (i + 1)
        optFound = true
        if opt.inputs.len == 0:
          # It's a flag
          hasValue = true
          flags.add(optName)
        else:
          # It's an option with inputs
          optValues.add(optName)
          while j < inputs.len and not tinyre.contains(inputs[j], reExclude):
            hasValue = true
            optValues.add(inputs[j])
            inc(j)
        # If the option has no inputs and is not a flag
        if hasValue == false:
          optFound = false
          optValues.setLen(optValues.len - 1)
        break
    # If no options are provided, default values will be used
    if not optFound and opt.inputs.len > 0:
      optValues.add(optName)
      optValues.add(opt.inputs)
    if optValues.len > 0:
      data.add((data: optValues))
  return (flags, data)

# Get the value of an option
proc getArgsValue*(data: CmdosArgs, optName: string): seq[string] =
  for arg in data:
    if arg.data.len > 0 and arg.data[0] == optName:
      # Returns all values after the option name
      result = arg.data[1..^1]

# Get the value of a flag
proc getFlagsValue*(data: CmdosFlags, optName: string): bool =
  var value: bool
  for flag in data:
    if flag == optName:
      value = true
      break
  result = value
