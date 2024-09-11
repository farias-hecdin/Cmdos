import std/strutils

#-- ANSI Color code (thanks to: https://gist.github.com/JBlond/2fea43a3049b38287e5e9cefc87b2124)
const
  unstyle* = "\e[0m"
  bold* = "\e[1;97m"
  underline* = "\e[4;37m"
  emphasis* = bold & underline
  red* = "\e[38;5;196m"

#-- Show a error message
proc errorText*(message: string): string =
  result = "$2$4Error:$3 $1" % [message, bold, unstyle, red]
