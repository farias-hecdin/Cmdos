# Documentación

- [Documentación](#documentacin)
  - [Procs](#procs)
    - [`processArgs`](#processargs)
    - [`processHelp`](#processhelp)
  - [Types](#types)
    - [`CmdosData`](#cmdosdata)

## Procs

### `processArgs`

La función `processArgs` se utiliza para interpretar y procesar las entradas del usuario para un comando específico.

```nim
proc processArgs*(cmd: static CmdosCmd, inputs: seq[string] = defaultArgs): CmdosData
```

* `cmd`: El comando específico que se va a procesar. Este parámetro es obligatorio y debe ser de tipo CmdosCmd (ver [Types](#types)).
* `inputs` (opcional): Una secuencia de cadenas de texto que representan las entradas del usuario. Si no se proporcionan, se utilizarán las entradas por defecto.

### `processHelp`

La función `processHelp` genera un mensaje de ayuda basado en los datos proporcionados. Es útil para mostrar al usuario cómo utilizar un comando o conjunto de comandos.

```nim
proc processHelp*(data: static Cmdos): string
```

* `data`: Los datos que se utilizarán para generar el mensaje de ayuda (ver [Types](#types)).

## Types

```nim
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
    version*: string
    cmds*: seq[CmdosCmd]
```

### `CmdosData`

El tipo `CmdosData` se utiliza para manejar los datos procesados por [`processArgs`](#processargs).

```nim
type
  CmdosData* = seq[tuple[data: seq[string]]] # Secuencia de tuplas que contienen los datos procesados.
```

