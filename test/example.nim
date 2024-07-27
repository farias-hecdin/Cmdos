import std/[os]
import "../src/cmdos"

const Help = CmdosCmd(
  names: @["-h", "--help"],
  desc: "Displays this help screen.",
)

const Version = CmdosCmd(
  names: @["-v", "--version"],
  desc: "Displays the version number.",
)

const Add = CmdosCmd(
  names: @["add"],
  desc: "Adds a new book to the library.",
  args: @[
    CmdosArg(
      names: @["-t", "--title"],
      inputs: @["The Great Book"],
      desc: "The title of the book.",
      placeholder: "<string>",
    ),
    CmdosArg(
      names: @["-a", "--author"],
      inputs: @["John Doe", "Susan Dek"],
      desc: "The author of the book.",
      placeholder: "<string>...",
    ),
    CmdosArg(
      names: @["-p", "--pages"],
      inputs: @["800"],
      desc: "The number of pages in the book.",
      placeholder: "<int>",
    ),
  ],
)

const Init = [
  Cmdos(
    name: "Example",
    version: "1.0.X",
    cmds: @[Add, Version, Help],
  )
]

# Init app
proc run() = (
  if paramCount() > 0:
    case paramStr(1):
      of "-h", "--help":
        const help = processHelp(Init)
        echo help
      of "-v", "--version":
        echo Init[0].version
      of "add":
        var values = processArgs(Add, false)
        echo values
      else:
        echo "Invalid option"
)

run()
