import std/[strutils, sequtils]
import types, utils, color

const firstMargin: string = blank(2)
const leftMargin: string = blank(4)
const whitespace: string = firstMargin & leftMargin

#-- Wrap message
proc wrapMessage(message: string, maxLength: int): seq[string] =
  let leftMargin = maxLength + whitespace.len
  if message.len > 99:
    result.add(wrapText(message, 99, 2, leftMargin))
  else:
    result.add(firstMargin & message)

#-- Create the Usage section
proc makeMsgUsage(data: static Cmdos): seq[string] =
  var message: seq[string]
  var spacing = (data.name).len - 3
  result.add("$#Usage:$#" % [styleUnderline, styleReset])

  for cmd in data.cmds:
    message.add("[$#]" % [cmd.names.join("/")])
  result.add(wrapMessage(data.name & " " & message.join(" "), spacing))

#-- Create the Commands section
proc makeMsgCommands(data: static Cmdos): seq[string] =
  let cmds = data.cmds
  let maxLength: int = cmds.mapIt(it.names.join(", ").len + 1).max
  result.add("$#Commands:$#" % [styleUnderline, styleReset])

  for cmd in cmds:
    let name: string = cmd.names.join(", ") & (if cmd.opts.len > 0: " [options]" else: "")
    let spacing: string = blank(maxLength - name.len + leftMargin.len)
    let message: string = name & spacing & cmd.desc
    result.add(wrapMessage(message, maxLength))

#-- Create the Options section
proc makeMsgOptions(data: static Cmdos): seq[string] =
  for cmd in data.cmds:
    if cmd.opts.len > 0:
      let longName = utils.getLongestWord(cmd.names)
      let maxLength: int = cmd.opts.mapIt(it.names.join(", ").len + it.label.len + 1).max
      result.add("\n$#Options for: '$#'$#" % [styleUnderline, longName, styleReset])

      for opt in cmd.opts:
        let name: string = (
          if areSeqEqual(opt.names, cmd.names): opt.label
          else: "$# $#" % [opt.names.join(", "), opt.label]
        )
        let spacing: string = blank(maxLength - name.len + leftMargin.len)
        let description: string = opt.desc & " (df: $#)" % [opt.inputs.join(", ")]
        let message: string = name & spacing & description
        result.add(wrapMessage(message, maxLength))

#-- Process the help screen
proc processHelp*(data: static Cmdos): string =
  const usage: string = makeMsgUsage(data).join("\n") & "\n"
  const commands: string = makeMsgCommands(data).join("\n")
  const options: string = makeMsgOptions(data).join("\n")
  result = [usage, commands, options].join("\n") & "\n"

