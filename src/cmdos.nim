import std/[os, strformat, strutils, sequtils]

type
  #Arg* = object
  #  short*: string
  #  long*: string
  #  default*: string
  #  desc*: string
  #  multi*: bool = false
  Arg* = tuple[
    short: string,
    long: string,
    default: string,
    desc: string,
    multi: bool,
  ]

  Cmd* = object
    names*: array[2, string]
    desc*: string
    args*: seq[Arg]

  Help* = tuple[
    margin: int = 2,
    spacing: int = 3,
  ]

  Cmdos* = object
    name*: string
    version*: string
    cmds*: seq[Cmd]
    help*: Help

type
  Cmdtype* = static[array[1, Cmdos]]

include "./cmdosArg"
include "./cmdosHelp"
