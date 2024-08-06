import os
import "../src/cmdos"

# Command number third
const Help = CmdosCmd(
  names: @["-h", "--help"],
  desc: "Displays this help screen.",
)

# Command number two
const Version = CmdosCmd(
  names: @["-v", "--version"],
  desc: "Displays the version number.",
)

# Command number one
const Add = CmdosCmd(
  names: @["add"],
  desc: "Adds a new book to the library.",
  args: @[
    CmdosArg(
      names: @["-t", "--title"],
      inputs: @["The Great Book"],
      desc: "The title of the book.",
      label: "<string>",
    ),
    CmdosArg(
      names: @["-a", "--author"],
      inputs: @["John Doe", "Susan Dek"],
      desc: "The author of the book.",
      label: "<string>...",
    ),
    CmdosArg(
      names: @["-p", "--pages"],
      inputs: @["800"],
      desc: "The number of pages in the book.",
      label: "<int>",
    ),
  ],
)

const Command = Cmdos(
  name: "Example",
  version: "1.0.X",
  cmds: @[Add, Version, Help],
)

# Init app
proc main() =
  if paramCount() > 0:
    case paramStr(1):
      # Generate a help message
      of "-h", "--help":
        const help = processHelp(Command)
        echo help
      # Generate a version message
      of "-v", "--version":
        echo Command.version
      # Process the input arguments for the “Add” command.
      of "add":
        var values = processArgs(Add, true)
        echo values
      else:
        echo "Invalid option"

main()

