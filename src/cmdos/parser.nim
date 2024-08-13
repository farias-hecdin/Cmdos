import std/[os, terminal, strutils], pkg/[tinyre]
import types

#-- Show a error message
proc showError(location, message: string) =
  let location = "Error at [$#]:\n  " % [location]
  styledEcho(fgRed, location, resetStyle, message)
  quit(QuitFailure)

#-- Process input options
let defaultArgs: seq[string] = os.commandLineParams()

proc processArgs*(cmd: static CmdosCmd, inputs: seq[string] = defaultArgs): CmdosData =
  let reExclude = tinyre.re"^-"

  for opt in cmd.opts:
    let optName = opt.names[0]
    var optValues: seq[string]
    var optFound = false

    for i in 0..<inputs.len:
      if inputs[i] in opt.names:
        var j = (i + 1)
        optFound = true
        # If the options receives more inputs
        if opt.inputs.len > 1:
          optValues.add(optName)
          while j < inputs.len and not tinyre.contains(inputs[j], reExclude):
            optValues.add(inputs[j])
            inc(j)
        # If only one options is provided
        else:
          optValues.add(optName)
          if j < inputs.len:
            optValues.add(inputs[j])
        break
    # If no options is provided, default values will be used
    if not optFound:
      if opt.inputs.len <= 0:
        showError(cmd.names[0], "The number of inputs provided is invalid.")
      optValues.add(optName)
      optValues.add(opt.inputs)
    result.add((data: optValues))

