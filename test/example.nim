import std/[strformat, strutils, sequtils]
import "../src/cmdos"

include "./example_data"

#-- Process the help screen
proc processHelp(data: Cmdtype): string = (
  const cmdos = data[0]
  const appName: string = cmdos.appName
  const marginFix: string = (" ").repeat(cmdos.helpMargin)
  const spacingFix: int = cmdos.helpSpacing

  # Design the “Usage” section
  const getUsageSection = formatUsageSection(data).join(" ")
  const usage_section: string = "Usage:\n$1$2 $3\n" % [marginFix, appName, getUsageSection]

  # Design the “Commands” section
  const getCommandsSection = formatCommandsSection(data, marginFix).join("\n")
  const commands_section: string = "Commands:\n$1" % [getCommandsSection]

  # Design the “Options” section
  # Design the “X options” section
  result = usage_section & "\n" & commands_section & "\n"
)

#[
# Option line ---------------------------------------------------------------------------
for command in data[0].cmds:
 var (name, _) = getLongestWord(command.name)
 var argm: seq[string]

 if len(command.name) > 1: name = command.name[1]
 else: name = command.name[0]

 if name != "--help" or name != "--version":
   for a in command.args:
     add(argm, a.short & ", " & a.long & " " & a.desc)

   var OPTIONS_LINE = name & " options:\n" & argm.join("\n")
   echo OPTIONS_LINE

# ---------------------------------------------------------------------------

--Add options:
  -l, --case-sensitive    (04)The number of pages in the book
  -t, --title             (13)The title of the book
  -a, --author            (12)The author of the book
]#

const message = processHelp(Init)
echo message
