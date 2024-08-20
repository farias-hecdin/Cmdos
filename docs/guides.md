# Documentación

- [Documentación](#documentacin)
  - [Procs](#procs)
    - [`processCmd`](#processcmd)
    - [`processHelp`](#processhelp)
    - [`getArgsValue`](#getargsvalue)
    - [`getFlagsValue`](#getflagsvalue)
  - [Types](#types)
    - [`CmdosArgs` y `CmdosFlags`](#cmdosargs-y-cmdosflags)

## Procs

### `processCmd`

La función `processArgs` se utiliza para interpretar y procesar las entradas del usuario para un comando específico.

```nim
proc processCmd*(cmd: static CmdosCmd, ignoreFirst: bool = false, inputs: seq[string] = defaultArgs): (CmdosFlags, CmdosArgs) =
```

* **cmd**: El comando específico que se va a procesar. Este parámetro es obligatorio y debe ser de tipo `CmdosCmd` (ver [Types](#types)).
* **ignoreFirst**:
* **inputs** (opcional): Una secuencia de cadenas de texto que representan las entradas del usuario. Si no se proporcionan, se utilizarán las entradas por defecto.

### `processHelp`

La función `processHelp` genera un mensaje de ayuda basado en los datos proporcionados. Es útil para mostrar al usuario cómo utilizar un comando o conjunto de comandos.

```nim
proc processHelp*(data: static Cmdos): string
```

* **data**: Los datos que se utilizarán para generar el mensaje de ayuda (ver [Types](#types)).

### `getArgsValue`

```nim
# Get the value of an option
proc getArgsValue*(data: CmdosArgs, optName: string): seq[string]
```

### `getFlagsValue`

```nim
# Get the value of a flag
proc getFlagsValue*(data: CmdosFlags, optName: string): bool
```

## Types

```nim
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
```

### `CmdosArgs` y `CmdosFlags`

El tipo `CmdosArgs` y `CmdosFlags` se utiliza para manejar los datos procesados por [`processCmd`](#processargs).

```nim
type
  CmdosArgs* = seq[tuple[data: seq[string]]]
  CmdosFlags* = seq[string]
```

