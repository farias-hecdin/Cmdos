import os
import "../src/cmdos"

var book = Cmdos(
  args: @[
    Arg(short: "-t", long: "--title", default: "The Great Book"),
    Arg(short: "-a", long: "--author", default: "John Doe"),
    Arg(short: "-p", long: "--pages", default: "300")
  ],
  opts: @["* The book titled '", "' written by ", " has ", " pages."]
)

var music = Cmdos(
  args: @[
    Arg(short: "-m", long: "--music", default: "Greatest Hits"),
    Arg(short: "-a", long: "--artist", default: "The Band"),
    Arg(short: "-y", long: "--year", default: "2022"),
  ],
  opts: @["* The album '", "' by ", " was released in ", "."]
)


# Show a help message
proc help() =
  echo """
  Usage:
    example_1 [book]               [-t/--title -a/--author -p/--pages] <value>
    example_1 [-m/--music] <name>  [-a/--artist -y/--year] <value>
  """


# Show the values
proc showValues(inputType: object, opts: seq[string], isBook: bool) =
  #-- Process the inputs from the user and default values
  let input = processArgs(inputType, isBook)
  #-- Extract a tuple that contains the inputs from the user and the arguments
  let (arg, value) = extractPairs(input)

  echo "1. Input: ", input
  echo "2. Args: ", arg
  echo "3. Values: ", value
  echo opts[0], value[0], opts[1], value[1], opts[2], value[2], opts[3]


# Launch the app
proc run() =
  if paramCount() > 0:
    case paramStr(1):
      of "book":
        showValues(book, book.opts, true)
      of "-m", "--music":
        showValues(music, music.opts, false)
      else:
        echo "Warning: Invalid argument."
  else:
    help()


when isMainModule:
  run()
