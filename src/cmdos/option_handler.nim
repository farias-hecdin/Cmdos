import std/[os, strutils], pkg/tinyre
import types, utils, text_styled

#-- Process input options
let defaultArgs: seq[string] = os.commandLineParams()

proc processCmd*(cmd: static CmdosCmd, ignoreFirstCmd: bool = false, inputs: seq[string] = defaultArgs): (CmdosFlags, CmdosArgs) =
  # Validate the command
  when not validateCmdosCmd(cmd):
    quit(errorText(&"There is an error in 'CmdosCmd' {cmd.names}"), 1)

  let reExclude = tinyre.re"^-"
  var ignoreFirst = ignoreFirstCmd
  var collectedValues: seq[string]
  var flags: CmdosFlags = @[]
  var data: CmdosArgs = @[]

  # If `ignoreFirst` is true, capture all initial arguments.
  if ignoreFirst and inputs.len > 0:
    collectedValues.add("")
    for i in 0..<inputs.len:
      if tinyre.contains(inputs[i], reExclude): break
      collectedValues.add(inputs[i])

  for opt in cmd.opts:
    var optLongName = getLongestWord(opt.names)
    var optValues: seq[string]
    # Iterate over the input arguments
    for i in 0..<inputs.len:
      if inputs[i] in opt.names:
        var j = (i + 1)
        if opt.inputs.len == 0:
          # It's a flag
          flags.add(optLongName)
        else:
          # It's an option with inputs
          optValues.add(optLongName)
          while j < inputs.len and not tinyre.contains(inputs[j], reExclude):
            optValues.add(inputs[j])
            inc(j)
        break

    # If no options are provided, default values will be used
    if optLongName == "" and collectedValues.len > 1 and ignoreFirst:
      optValues.add(collectedValues)
    ignoreFirst = false
    if optValues.len == 0 and opt.inputs.len > 0:
      optValues.add(optLongName)
      optValues.add(opt.inputs)
    if optValues.len > 0:
      data.add((data: optValues))
  return (flags, data)

# Get the value of an option
proc getArg*(data: CmdosArgs, optLongName: string): seq[string] =
  for arg in data:
    if arg.data.len > 0 and arg.data[0] == optLongName:
      # Returns all values after the option name
      result = arg.data[1..^1]

# Get the value of a flag
proc getFlag*(data: CmdosFlags, optLongName: string): bool =
  var value: bool
  for flag in data:
    if flag == optLongName:
      value = true
      break
  result = value
