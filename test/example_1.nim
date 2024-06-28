import os
import "../src/cmdos"

var book = Cmdos(
  args: @[
    Arg(short: "-t", long: "--title", default: "The Great Book"),
    Arg(short: "-a", long: "--author", default: "John Doe"),
    Arg(short: "-p", long: "--pages", default: "300")
  ],
  values: @["-t", "My Book", "-a", "Jane Doe", "-p", "250"]
)

var music = Cmdos(
  args: @[
    Arg(short: "-m", long: "--music", default: "Greatest Hits"),
    Arg(short: "-a", long: "--artist", default: "The Band"),
    Arg(short: "-y", long: "--year", default: "2022"),
  ],
  values: @["-m", "Masterpiece", "-a", "The Orchestra", "-y", "2010"]
)

proc help() =
  echo """
  Usage:
    example_1 [book]               [-t/--title -a/--author -p/--pages] <value>
    example_1 [-m/--music] <name>  [-a/--artist -y/--year] <value>
  """

proc run() =
  var input: seq[string]

  if paramCount() > 0:
    case paramStr(1):
      of "book":
        input = processArgs(book, true)
        var (args, values) = extractPairs(input)
        echo "Input: ", input
        echo "Args: ", args
        echo "Values: ", values
      of "-m", "--music":
        input = processArgs(music, false)
        var (args, values) = extractPairs(input)
        echo "Input: ", input
        echo "Args: ", args
        echo "Values: ", values
      else:
        echo "Warning: Invalid argument."
  else:
    help()

when isMainModule:
  run()
