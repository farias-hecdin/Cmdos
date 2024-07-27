import std/[strutils, sequtils]
import types

const margin: string = (" ").repeat(2)

#-- ANSI Color code (thanks to: https://gist.github.com/JBlond/2fea43a3049b38287e5e9cefc87b2124)
const
  bold = "\e[1;97m"
  underline = bold & "\e[4;37m"
  reset = "\e[0m"

#-- Get the longest word in an array and its length
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
  for group in data:
    for cmd in group.cmds:
      result.add("[" & cmd.names.join("/") & "]")
)

#-- Create the Commands section
proc formatCommands(data: CmdosType): seq[string] = (
  let cmds = data[0].cmds
  let maxCmdLen = cmds.mapIt(it.names.join(", ").len).max

  for cmd in cmds:
    let cmdName = cmd.names.join(", ")
    let spacing = (" ").repeat(maxCmdLen - cmdName.len + 3)
    result.add(margin & cmdName & spacing & cmd.desc)
)

#-- Create the Options section
proc formatOptions(data: CmdosType): seq[string] = (
  let cmds = data[0].cmds
  for cmd in cmds:
    if cmd.args.len > 0:
      let (longestName, _) = getLongestWord(cmd.names)
      let placeholderLen: int = cmd.args.mapIt(it.placeholder.len).max
      let maxArgLen: int = cmd.args.mapIt(it.names.join(", ").len).max + placeholderLen
      result.add("\n$#$# options:$#" % [underline, longestName, reset])

      for arg in cmd.args:
        let argName = arg.names.join(", ") & " " & arg.placeholder
        let spacing = (" ").repeat(maxArgLen - argName.len + 3)
        result.add(margin & argName & " " & spacing & arg.desc)
)

#-- Process the help screen
proc processHelp*(data: CmdosType): string = (
  const cmdos = data[0]
  const app: string = cmdos.name

  const usageSection = "$1Usage:$2\n$4$3 $5\n" % [underline, reset, app, margin, formatUsage(data).join(" ")]
  const commandsSection = "$1Commands:$2\n$3" % [underline, reset, formatCommands(data).join("\n")]
  const optionsSection = formatOptions(data).join("\n")

  result = [usageSection, commandsSection, optionsSection].join("\n") & "\n"
)

