import std/strutils
import pkg/hex2ansi

#-- ANSI Color code (thanks to: https://gist.github.com/JBlond/2fea43a3049b38287e5e9cefc87b2124)
const
  unstyle* = "\e[0m"
  bold* = "\e[1;97m"
  underline* = "\e[4;37m"
  emphasis* = bold & underline
  red* = "#FF2222"

#-- Show a error message
proc errorText*(message: string) =
  echo "$2$4Error:$3 $1" % [message, bold, unstyle, fg(red)]
  quit(QuitFailure)
