import std/[os, strutils, terminal], pkg/[tinyre]

type
  CmdosArg* = object
    names*, inputs*: seq[string]
    desc*, placeholder*: string

  CmdosCmd* = object
    names*: seq[string]
    desc*: string
    args*: seq[CmdosArg]

  Cmdos* = object
    name*, version*: string
    cmds*: seq[CmdosCmd]

type
  CmdosType* = static[array[1, Cmdos]]

proc showError(location, message: string) = (
  let location = "Error at [$#]:\n  " % [location]
  styledEcho(fgRed, location, resetStyle, message)
  quit(QuitFailure)
)

#-- Process input arguments
let defaultArgs: seq[string] = os.commandLineParams()

proc processArgs*(cmd: CmdosCmd, ignoreFirst: bool, inputArgs: seq[string] = defaultArgs): seq[tuple[data: seq[string]]] = (
  let startIndex = if ignoreFirst: 1 else: 0
  let reExclude = tinyre.re"^-"

  for arg in cmd.args:
    let argName = arg.names[0]
    var argValues: seq[string]
    var argFound = false

    for i in startIndex..<inputArgs.len:
      if inputArgs[i] in arg.names:
        var j = (i + 1)
        argFound = true
        # If the argument receives more inputs
        if arg.inputs.len > 1:
          argValues.add(argName)
          while j < inputArgs.len and not tinyre.contains(inputArgs[j], reExclude):
            argValues.add(inputArgs[j])
            inc(j)
        # If only one argument is provided
        else:
          argValues.add(argName)
          if j < inputArgs.len:
            argValues.add(inputArgs[j])
        break
    # If no argument is provided, default values will be used
    if not argFound:
      if arg.inputs.len <= 0:
        showError(cmd.names[0], "The number of inputs provided is invalid.")
      argValues.add(argName)
      argValues.add(arg.inputs)
    result.add((data: argValues))
)

