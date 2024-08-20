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
  CmdosArgs* = seq[tuple[data: seq[string]]]
  CmdosFlags* = seq[string]

