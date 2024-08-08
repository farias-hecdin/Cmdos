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
  result.add("$1Usage:$2\n$3$4" % [underline, reset, margin, data.name])

  for cmd in data.cmds:
    result.add("[" & cmd.names.join("/") & "]")

#-- Create the Commands section
proc makeMsgCommands(data: static Cmdos): seq[string] =
  let cmds = data.cmds
  let maxLen: int = cmds.mapIt(it.names.join(", ").len).max
  result.add("$1Commands:$2" % [underline, reset])

  for cmd in cmds:
    let name: string = cmd.names.join(", ") & (if cmd.args.len > 0: " [options]" else: "")
    let space: string = (" ").repeat(maxLen + 3 - name.len)
    result.add(margin & name & space & cmd.desc)

#-- Create the Options section
proc makeMsgOptions(data: static Cmdos): seq[string] =
  for cmd in data.cmds:
    if cmd.args.len > 0:
      let (longName, _) = getLongestWord(cmd.names)
      let maxLen: int = cmd.args.mapIt(it.names.join(", ").len + it.label.len + 1).max
      result.add("\n$1Options for: $2$3" % [underline, longName, reset])

      for arg in cmd.args:
        let name: string = (
          if areSeqEqual(arg.names, cmd.names): arg.label
          else: arg.names.join(", ") & " " & arg.label
        )
        let space: string = (" ").repeat(maxLen + 3 - name.len)
        let default: string = "(default: " & arg.inputs.join(", ") & ")"
        result.add(margin & name & space & arg.desc & " " & default)

#-- Process the help screen
proc processHelp*(data: static Cmdos): string =
  const usage = makeMsgUsage(data).join(" ") & "\n"
  const commands = makeMsgCommands(data).join("\n")
  const options = makeMsgOptions(data).join("\n")
  result = [usage, commands, options].join("\n") & "\n"

