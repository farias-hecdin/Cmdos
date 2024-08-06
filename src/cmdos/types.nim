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
  CmdosData* = seq[tuple[data: seq[string]]]
