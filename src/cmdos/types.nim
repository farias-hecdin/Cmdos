type
  CmdosOpt* = object
    names*: seq[string]
    inputs*: seq[string]
    desc*: string
    label*: string

  CmdosCmd* = object
    names*: seq[string]
    desc*: string
    opts*: seq[CmdosOpt]

  Cmdos* = object
    name*: string
    cmds*: seq[CmdosCmd]

type
  CmdosArgs* = seq[tuple[data: seq[string]]]
  CmdosFlags* = seq[string]

