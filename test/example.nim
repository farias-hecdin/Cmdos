import std/os
import "../src/cmdos"

const longText = "Provides detailed information about the program, including its purpose, features, and development history. This option gives users insight into the goals of the software, the team behind it, and any future updates or enhancements planned."

# Creating a command that does not accept options
const About = CmdosCmd(names: @["-a", "--about"], desc: longText)
const Config = CmdosCmd(names: @["-c", "--config"], desc: "Configures program options.")
const Donate = CmdosCmd(names: @["-d", "--donate"], desc: "Information on how to donate to the project.")
const Help = CmdosCmd(names: @["-h", "--help"], desc: "Displays this help screen and exit.")
const License = CmdosCmd(names: @["-l", "--license"], desc: "Displays license information.")
const More = CmdosCmd(names: @["-m", "--more"], desc: "Shows more options.")
const Version = CmdosCmd(names: @["-v", "--version"], desc: "Shows the current version of the program.")

# Creating a command that accepts options
const Create = CmdosCmd(
  names: @["create"],
  desc: "Adds a new book to the library.",
  opts: @[
    # Long form: Including field names.
    (names: @["-t", "--title"], inputs: @["The Big Book"], desc: "The title of the book.", label: "<name>"),
    # Short form: excluding field names
    (@["-a", "--author"], @["John Doe", "Susan Dek"], "Adds a new book to the library.", "<names>"),
    (@["-p", "--pages"], @["800"], longText, "<number>"),
    (@["-r", "--reset"], @[], longText, ""),
  ],
)

# This object is useful for creating a 'Help message'
const Command = Cmdos(
  name: "Example",
  cmds: @[Create, Help, Config, Version, License, Donate, About, More]
)

# Setup an example app
proc main() =
  if paramCount() > 0:
    case paramStr(1)
    # Generate a 'help message'
    of "-h", "--help":
      const help = processHelp(Command)
      echo help
    # Process the input arguments for the 'Create' command.
    of "create":
      var values = processArgs(Create, false) # 'false' ignore first argument. (default: false)
      echo values
    else:
      echo "Invalid option."

# Run the app
when isMainModule:
  main()
