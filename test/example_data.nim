# @nvim-nolsp

const Help = CmdosArg(
  name: @["-h", "--help"],
  desc: "Displays this help screen.",

)
const Version = CmdosArg(
  name: @["-v", "--version"],
  desc: "Displays the version number.",
)

const Add = CmdosArg(
  name: @["--add"],
  desc: "Adds a new book to the library.",
  args: @[
    Arg(short: "-t", long: "--title", default: "The Great Book", desc: "The title of the book."),
    Arg(short: "-a", long: "--author", default: "John Doe", desc: "The author of the book."),
    Arg(short: "-l", long: "--pages", default: "800", desc: "The number of pages in the book.")
  ],
)

const Search = CmdosArg(
  name: @["--search"],
  desc: "Searches for books in the library.",
  args: @[
    Arg(short: "-t", long: "--title", default: "", desc: "The title of the book to search for."),
    Arg(short: "-a", long: "--author", default: "", desc: "The author of the book to search for."),
    Arg(short: "-c", long: "--case-sensitive", default: "off", desc: "Perform a case-sensitive search (default is case-insensitive).")
  ],
)

const Init = [
  Cmdos(
    appName: "Example",
    appVersion: "1.0.X",
    cmds: @[Add, Search, Version, Help],
  )
]

