type
  CmdosArg* = object
    names*, inputs*: seq[string]
    desc*, label*: string

  CmdosCmd* = object
    names*: seq[string]
    desc*: string
    args*: seq[CmdosArg]

  Cmdos* = object
    name*, version*: string
    cmds*: seq[CmdosCmd]

type
  CmdosType* = static[array[1, Cmdos]]


