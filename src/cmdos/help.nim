import std/[strutils, sequtils, sets]
import types

const margin: string = (" ").repeat(2)

#-- ANSI Color code (thanks to: https://gist.github.com/JBlond/2fea43a3049b38287e5e9cefc87b2124)
const bold = "\e[1;97m"
const underline = (bold & "\e[4;37m")
const reset = "\e[0m"

#-- Compare two sequences
proc areSeqEqual(seq1, seq2: seq[string]): bool =
  return toHashSet(seq1) == toHashSet(seq2)

#-- Get the longest word in an array and its length
proc getLongestWord(words: seq[string]): (string, int) =
  var longestWord = ""
  var maxLength = 0

  for word in words:
    if word.len > maxLength:
      maxLength = word.len
      longestWord = word
  result = (longestWord, maxLength)

#-- Create the Usage section
proc makeMsgUsage(data: static Cmdos): seq[string] =
  for cmd in data.cmds:
    result.add("[" & cmd.names.join("/") & "]")

#-- Create the Commands section
proc makeMsgCommands(data: static Cmdos): seq[string] =
  let cmds = data.cmds
  let text = (" " & "[options]")
  var maxCmdLen: int = cmds.mapIt(it.names.join(", ").len).max

  for cmd in cmds:
    if cmd.args.len > 0:
      maxCmdLen = (maxCmdLen + text.len)
      break

  for cmd in cmds:
    var cmdName: string = cmd.names.join(", ") & (
      if cmd.args.len > 0: text
      else: ""
    )

    let spacing: string = (" ").repeat(maxCmdLen - cmdName.len + 3)
    result.add(margin & cmdName & spacing & cmd.desc)

#-- Create the Options section
proc makeMsgOptions(data: static Cmdos): seq[string] =
  let cmds = data.cmds
  for cmd in cmds:
    if cmd.args.len > 0:
      let (longestName, _) = getLongestWord(cmd.names)
      let labelLen: int = cmd.args.mapIt(it.label.len).max
      let maxArgLen: int = cmd.args.mapIt(it.names.join(", ").len).max + labelLen
      result.add("\n$1Options for: $2$3" % [underline, longestName, reset])

      for arg in cmd.args:
        let argName: string = (
          if areSeqEqual(arg.names, cmd.names): arg.label
          else: arg.names.join(", ") & " " & arg.label
        )

        let spacing: string = (" ").repeat(maxArgLen - argName.len + 3)
        result.add(margin & argName & " " & spacing & arg.desc)

#-- Process the help screen
proc processHelp*(data: static Cmdos): string =
  const usage = "$1Usage:$2\n$4$3 $5\n" % [underline, reset, data.name, margin, makeMsgUsage(data).join(" ")]
  const commands = "$1Commands:$2\n$3" % [underline, reset, makeMsgCommands(data).join("\n")]
  const options = makeMsgOptions(data).join("\n")

  result = [usage, commands, options].join("\n") & "\n"

