import std/os
import "../src/cmdos"

const longText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."

# Creating a command that does not accept options

const About = CmdosCmd(names: @["-a", "--about"], desc: longText)
const Help = CmdosCmd(names: @["-h", "--help"], desc: "Displays this help screen and exit.")
const License = CmdosCmd(names: @["-l", "--license"], desc: "Displays license information.")
const More = CmdosCmd(names: @["-m", "--more"], desc: "Shows more options.")
const Version = CmdosCmd(names: @["-v", "--version"], desc: "Shows the current version of the program.")

# Creating commands that accepts options

const Buy = CmdosCmd(
  names: @["buy"],
  desc: "Buys cryptocurrencies.",
  opts: @[
    CmdosOpt(names: @["-c", "--currency"], inputs: @["btc", "eth", "ltc"], desc: "The cryptocurrency to buy.", label: "<currency>"),
    CmdosOpt(names: @["-a", "--amount"], inputs: @["1.0"], desc: "The amount of cryptocurrency to buy.", label: "<amount>"),
    CmdosOpt(names: @["-p", "--price"], inputs: @["1000.0"], desc: longText, label: "<price>"),
    CmdosOpt(names: @["-r", "--reinvest"], desc: longText),
  ],
)

const Anything = CmdosCmd(
  names: @[""],
  opts: @[
    CmdosOpt(names: @["-btc", "--bitcoin"], desc: "Check Bitcoin price"),
    CmdosOpt(names: @["-ltc", "--litecoin"], desc: "Check Bitcoin price"),
    CmdosOpt(names: @["-eth", "--ethereum"], desc: "Check Ethereum price"),
  ]
)

# This object is useful for creating a 'Help message'
const Command = Cmdos(
  name: "CryptoApp",
  cmds: @[About, Anything, Buy, Help, License, More, Version]
)

# Setup an example app
proc main() =
  if paramCount() > 0:
    case paramStr(1)
    # Generate a 'help message'
    of "-h", "--help":
      var help = processHelp(Command)
      echo help
    # Process the input arguments for the commands.
    of "buy":
      var (flags, args) = processCmd(Buy)
      echo flags, args
    else:
      var (flags, _) = processCmd(Anything)
      echo flags
      if getFlagsValue(flags, "--ethereum"):
        echo "US$ 1940.0"
      elif getFlagsValue(flags, "--bitcoin"):
        echo "US$ 65000.0"
      elif getFlagsValue(flags, "--litecoin"):
        echo "US$ 110.0"
      else:
        echo "Invalid option."

# Run the app
when isMainModule:
  main()
