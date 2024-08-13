import os
import "../src/cmdos"

const longText = "Provides detailed information about the program, including its purpose, features, and development history. This option gives users insight into the goals of the software, the team behind it, and any future updates or enhancements planned. It may also include links to the official  website, user guides, and community forums for additional support."

# Command list
const About   = CmdosCmd(names: @["-a", "--about"], desc: longText)
const Config  = CmdosCmd(names: @["-c", "--config"], desc: "Configures program options.")
const Donate  = CmdosCmd(names: @["-d", "--donate"], desc: "Information on how to donate to the project.")
const Help    = CmdosCmd(names: @["-h", "--help"], desc: "Displays this help screen and exit.")
const License = CmdosCmd(names: @["-l", "--license"], desc: "Displays license information.")
const More    = CmdosCmd(names: @["-m", "--more"], desc: "Shows more options.")
const Version = CmdosCmd(names: @["-v", "--version"], desc: "Shows the current version of the program.")

const Add = CmdosCmd(
  names: @["add"],
  desc: "Adds a new book to the library.",
  opts: @[
    CmdosOpt(
      names: @["add"],
      inputs: @["The Great Book"],
      desc: "The title of the book.",
      label: "<Bookname>",
    ),
    CmdosOpt(
      names: @["-a", "--author"],
      inputs: @["John Doe", "Susan Dek"],
      desc: "Adds a new book to the library.",
      label: "<names>",
    ),
    CmdosOpt(
      names: @["-p", "--pages"],
      inputs: @["800"],
      desc: "The number of pages in the book.",
      label: "<number>",
    ),
  ],
)

const Command = Cmdos(
  name: "Example",
  version: "1.0.X",
  cmds: @[
    Add,
    Help,
    Config,
    Version,
    License,
    Donate,
    About,
    More,
  ],
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
        var values = processArgs(Add)
        echo values
      else:
        echo "Invalid option."

# Run script
when isMainModule:
  main()
