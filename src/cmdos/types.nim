type
  CmdosCmd* = object
    names*: seq[string]
    desc*: string
    opts*: seq[tuple[
      names: seq[string],
      inputs: seq[string],
      desc: string,
      label: string
    ]]

  Cmdos* = object
    name*: string
    cmds*: seq[CmdosCmd]

type
  CmdosData* = seq[tuple[data: seq[string]]]
