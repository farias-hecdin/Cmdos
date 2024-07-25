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
    help*: tuple[margin = 2, spacing = 2, styled: bool]

type
  CmdosType* = static[array[1, Cmdos]]

proc showError(location, message: string) =
  let location = "Error at [$#]:\n  " % [location]
  styledEcho(fgRed, location, resetStyle, message)
  quit(QuitFailure)

#-- Procesar los argumentos de entrada
var defaultArgs: seq[string] = os.commandLineParams()

proc processArgs*(self: CmdosCmd, ignoreFirst: bool, inputArgs: seq[string] = defaultArgs): seq[tuple[data: seq[string]]] = (
  let startIndex = if ignoreFirst: 1 else: 0
  let reExclude = tinyre.re"^-"

  assert(startIndex < inputArgs.len, "<startIndex> must be less than the length of inputArgs.")

  for arg in self.args:
    let argInputsLen: int = arg.inputs.len
    let argName: string = arg.names[0]
    var valueFound, argExists: bool = false
    var values: seq[string]

    for i in startIndex..<inputArgs.len:
      assert(i < inputArgs.len, "<i> must be less than the length of inputArgs.")
      for name in arg.names:
        if inputArgs[i] == name:
          argExists = true
          break

      if argExists:
        var j = i + 1
        if argInputsLen > 1:
          values.add(argName)
          while j < inputArgs.len and not tinyre.contains(inputArgs[j], reExclude):
            values.add(inputArgs[j])
            inc(j)
        else:
          values.add(argName)
          if j < inputArgs.len:
            values.add(inputArgs[j])
        valueFound = true
        break
    if not valueFound:
      if argInputsLen < 1:
        showError(self.names[0], "The number of inputs provided is invalid.")
      values.add(argName)
      values.add(arg.inputs)
    result.add((data: values))
)

# HELP SCREEN -----------------------------------------------------------------

#-- Obtener la palabra mas larga de un arreglo y su longitud
proc getLongestWord*(words: seq[string]): (string, int) = (
  var longestWord: string
  var maxLength = 0

  for word in words:
    let wordLength = word.len
    if wordLength > maxLength:
      maxLength = wordLength
      longestWord = word
  return (longestWord, maxLength)
)

#-- Crear la seccion Usage
proc formatUsageSection*(data: CmdosType): seq[string] = (
  var formattedCommands: seq[string]

  for commandGroup in data:
    for command in commandGroup.cmds:
      let formattedName = "[$1]" % [command.names.join("/")]
      formattedCommands.add(formattedName)
  return formattedCommands
)

#-- Crear la seccion Commands
proc formatCommandsSection*(data: CmdosType, margin: string): seq[string] = (
  let cmdos = data[0]
  let commands = cmdos.cmds
  var formattedLines: seq[string]
  var commandInfos: seq[(string, int)]
  var maxCommandNameLength = 0

  for command in commands:
    let commandName = command.names.join(", ")
    formattedLines.add(commandName)
    let (longestName, nameLength) = getLongestWord(formattedLines)
    if nameLength > maxCommandNameLength:
      maxCommandNameLength = nameLength
    commandInfos.add((formattedLines.join(""), nameLength))
    formattedLines = @[]

  for i, command in commands:
    let (commandName, _) = commandInfos[i]
    let spacing = (" ").repeat(maxCommandNameLength - commandName.len + cmdos.help.spacing)
    formattedLines.add(margin & commandName & spacing & command.desc)
  return formattedLines
)

