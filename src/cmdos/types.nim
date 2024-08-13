type
  CmdosOpt* = object
    names*, inputs*: seq[string]
    desc*, label*: string

  CmdosCmd* = object
    names*: seq[string]
    desc*: string
    opts*: seq[CmdosOpt]

  Cmdos* = object
    name*, version*: string
    cmds*: seq[CmdosCmd]

type
  CmdosData* = seq[tuple[data: seq[string]]]
