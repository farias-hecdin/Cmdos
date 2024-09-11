import std/[strutils, sequtils, algorithm]
import types, utils, text_styled

const firstMargin = blank(2)
const leftMargin = blank(4)

#-- Wrap message
proc wrapMessage(msg: string, maxLen: int): seq[string] =
  let leftMargin = (maxLen + firstMargin.len)
  if msg.len > 99:
    result.add(wrapText(msg, 99, 2, leftMargin))
  else:
    result.add(firstMargin & msg)

#-- Create the Usage section
proc makeMsgUsage(data: static Cmdos): seq[string] =
  let name = "$# " % [data.name]
  let space = name.len
  # Adds the header for the usage message
  result.add("$#Usage:$#" % [emphasis, unstyle])
  # Constructs the usage message
  var cmdNames: seq[string]
  for cmd in data.cmds:
    if "" in cmd.names:
      cmdNames.add("<options>")
    else:
      cmdNames.add("[$#]" % [cmd.names.join("/")])
  cmdNames.sort()
  let msg = name & cmdNames.join(" ")
  result.add(wrapMessage(msg, space))

#-- Create the Commands section
proc makeMsgCommands(data: static Cmdos): seq[string] =
  let cmds = data.cmds
  let suffix = " <options>"
  let maxLen = cmds.mapIt(it.names.join(", ").len + (if it.opts.len > 0: suffix.len else: 0)).max
  # Adds the header for the list of commands
  result.add("$#Commands:$#" % [emphasis, unstyle])

  # Iterates over each command and generates its message
  var cmdMsgs: seq[string]
  for cmd in cmds:
    let name = cmd.names.join(", ") & (if cmd.opts.len > 0: suffix else: "")
    let space = blank(maxLen + leftMargin.len - name.len)
    let msg = name & space & cmd.desc
    if "" in cmd.names:
      continue
    cmdMsgs.add(wrapMessage(msg, maxLen + 4))
  result.add(cmdMsgs)

#-- Create the Options section
proc makeMsgOptions(data: static Cmdos): seq[string] =
  for cmd in data.cmds:
    if cmd.opts.len > 0:
      let longName = utils.getLongestWord(cmd.names)
      let maxLen = cmd.opts.mapIt(it.names.join(", ").len + it.label.len).max
      # Adds the header for the options of the current command
      result.add("\n$#Options for: '$#'$#" % [emphasis, longName, unstyle])

      # Constructs the option message
      for opt in cmd.opts:
        let name = (
          if areSeqEqual(opt.names, cmd.names): opt.label
          else: "$# $#" % [opt.names.join(", "), opt.label]
        )
        let space = blank(maxLen + leftMargin.len - name.len)
        let showDfValue = (if opt.inputs.len > 0: " (df: '$#')" % [opt.inputs.join(", ")] else: "")
        let desc = opt.desc & showDfValue
        let msg = name & space & desc
        result.add(wrapMessage(msg, maxLen + 4))

#-- Process the help screen
proc processHelp*(data: static Cmdos): string =
  # Validate the command
  if not validateCmdos(data):
    let msg = errorText("There is two cmds.names with @['']")
    echo msg
    return msg

  const usage = makeMsgUsage(data).join("\n") & "\n"
  const commands = makeMsgCommands(data).join("\n")
  const options = makeMsgOptions(data).join("\n")
  result = [usage, commands, options].join("\n") & "\n"

