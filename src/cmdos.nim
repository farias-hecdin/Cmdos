import std/[os, strutils, sequtils, terminal], pkg/[tinyre]

type
  CmdosArg* = object
    names*, inputs*: seq[string]
    desc*: string

  CmdosCmd* = object
    names*: seq[string]
    desc*: string
    args*: seq[CmdosArg]

  Cmdos* = object
    name*, version*: string
    cmds*: seq[CmdosCmd]
    help*: tuple[margin = 2, spacing = 3, styled: bool]

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

# HELP SCREEN -----------------------------------------------------------------

#-- ANSI Color code
# Thanks to: https://gist.github.com/JBlond/2fea43a3049b38287e5e9cefc87b2124
const
  bold = "\e[1;97m"
  underline = bold & "\e[4;37m"
  reset = "\e[0m"

#-- Obtener la palabra mas larga de un arreglo y su longitud
proc getLongestWord(words: seq[string]): (string, int) = (
  var longestWord: string
  var maxLength = 0

  for word in words:
    if word.len > maxLength:
      maxLength = word.len
      longestWord = word
  result = (longestWord, maxLength)
)

#-- Create the Usage section
proc formatUsage(data: CmdosType): seq[string] = (
  for commandGroup in data:
    for command in commandGroup.cmds:
      result.add("[" & command.names.join("/") & "]")
)

#-- Create the Commands section
proc formatCommands(data: CmdosType, margin: string): seq[string] = (
  let cmdos = data[0]
  let commands = cmdos.cmds

  # Find the maximum length of command name
  let maxCommandNameLength = commands.mapIt(it.names.join(", ").len).max
  # Format command lines
  for command in commands:
    let commandName = command.names.join(", ")
    let spacing = " ".repeat(maxCommandNameLength - commandName.len + cmdos.help.spacing)
    result.add(margin & commandName & spacing & command.desc)
)

#-- Create the Options section
proc formatOptions(data: CmdosType, margin: string): seq[string] = (
  let cmdos = data[0]
  let commands = cmdos.cmds

  for command in commands:
    if command.args.len > 0:
      var (word, _) = getLongestWord(command.names)
      result.add("\n$#$# options:$#" % [underline, word, reset])
      let maxArgNameLength = command.args.mapIt(it.names.join(", ").len).max
      for arg in command.args:
        let argName = arg.names.join(", ")
        let spacing = " ".repeat(maxArgNameLength - argName.len + cmdos.help.spacing)
        result.add(margin & arg.names.join(", ") & " " & spacing & arg.desc)
)

#-- Process the help screen
proc processHelp*(data: CmdosType): string = (
  const cmdos = data[0]
  const app: string = cmdos.name
  const margin: string = (" ").repeat(cmdos.help.margin)

  const usageSection = "$#Usage:$#\n$#$# $#\n" % [underline, reset, margin, app, formatUsage(data).join(" ")]
  const commandsSection = "$#Commands:$#\n$#" % [underline, reset, formatCommands(data, margin).join("\n")]
  const optionsSection = formatOptions(data, margin).join("\n")

  result = [usageSection, commandsSection, optionsSection].join("\n") & "\n"
)

