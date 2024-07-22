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
proc formatUsageSection*(data: Cmdtype): seq[string] = (
  var formattedCommands: seq[string]

  for commandGroup in data:
    for command in commandGroup.cmds:
      let formattedName = "[$1]" % [command.name.join("/")]
      formattedCommands.add(formattedName)
  return formattedCommands
)

#-- Crear la seccion Commands
proc formatCommandsSection*(data: Cmdtype, margin: string): seq[string] = (
  let cmdos = data[0]
  let commands = cmdos.cmds
  var formattedLines: seq[string]
  var commandInfos: seq[(string, int)]
  var maxCommandNameLength = 0

  for command in commands:
    let commandName = command.name.join(", ")
    formattedLines.add(commandName)
    let (longestName, nameLength) = getLongestWord(formattedLines)
    if nameLength > maxCommandNameLength:
      maxCommandNameLength = nameLength
    commandInfos.add((formattedLines.join(""), nameLength))
    formattedLines = @[]

  for i, command in commands:
    let (commandName, _) = commandInfos[i]
    let spacing = (" ").repeat(maxCommandNameLength - commandName.len + cmdos.helpSpacing)
    formattedLines.add(margin & commandName & spacing & command.desc)

  return formattedLines
)

