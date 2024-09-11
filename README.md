> Translate this file into your native language using `Google Translate` or a [similar service](https://immersivetranslate.com).

# Cmdos

Cmdos es un pequeño módulo para **Nim** que facilita el procesamiento de argumentos de línea de comandos y la generación automática de mensajes de ayuda.

## 🗒️ Características

### Ventajas:

* Es muy fácil de implementar.
* Permite recibir múltiples entradas para un mismo argumento.
* Provee un generador de mensajes de ayuda que se crea en tiempo de compilación.
* Permite añadir flags.

### Desventajas:

* ~No permite argumentos solitarios; todos los argumentos deben recibir un valor por defecto.~
* No admite delimitadores para separar valores (por ejemplo: `-c=Red,Blue`, `-c=:Red:Blue`), solo espacios en blanco (`-a Red Blue`).
* No admite llamar un mismo argumento múltiples veces; es decir, `-c Red -c Blue` ignorará la segunda llamada del argumento.

## 🗒️ Instalación

Para instalar Cmdos, sigue los siguiente pasos:

```sh
nimble install https://github.com/farias-hecdin/Cmdos.git
```

## 🗒️ Uso

1. Primero, importa el módulo `pkg/Cmdos`, y el modulo `std/os` para capturar los argumentos de entrada.

```nim
import pkg/cmdos
import std/os
```

2. Define tus argumentos y sus valores predeterminados. Aquí tienes un ejemplo de cómo definir un comando con varios argumentos:

```nim
# Creating a command that does not accept options
const Help = CmdosCmd(
    names: @["-h", "--help"],
    desc: "Displays this help screen and exit."
)

# Creating a command that accepts options
const Create = CmdosCmd(
  names: @["create"],
  desc: "Adds a new book to the library.",
  opts: @[
    CmdosOpt(names: @["-t", "--title"], inputs: @["The Big Book"], desc: "The title of the book.", label: "<name>"),
    CmdosOpt(names: @["-a", "--author"], inputs: @["John Doe", "Susan Dek"], desc:"Adds a new book to the library.", label: "<names>"),
    CmdosOpt(names: @["-p", "--pages"], inputs: @["800"], desc: longText, label: "<number>"),
    CmdosOpt(names: @["-r", "--reset"], @[], longText), # Behaves as a flag if no input is given.
  ],
)
```

```nim
const Command = Cmdos(
  name: "Example",
  cmds: @[
    Add,
    Help
  ],
)
```

3. Procesa los argumentos y extrae los valores analizados. Aquí tienes un ejemplo de cómo hacerlo:

```nim
# Setup an example app
proc main() =
  if paramCount() > 0:
    case paramStr(1)
    # Generate a 'help message'
    of "-h", "--help":
      const help = processHelp(Command)
      echo help
    # Process the input arguments for the 'Create' command.
    of "create":
      var (flags, args) = processCmd(Create)
      echo flags, args
    else:
      echo "Invalid option."
```

4. Una vez que los argumentos han sido procesados, puedes utilizarlos en tu aplicación.

```nim
# Run the app
when isMainModule:
  main()
```

Puedes ejecutar el ejemplo anterior de la siguiente manera:

```sh
nim c example.nim
```

```sh
./example create --title "Lorem Ipsum" --author "Jane Doe" --pages 125
```

Aquí esta un [ejemplo](./test/example.nim) completo que demuestra cómo usar `Cmdos`.

### Documentación

Para más detalles, visita la [documentación](docs/guides.md).

## 🛡️ Licencia

Cmdos está bajo la licencia MIT. Consulta el archivo `LICENSE` para obtener más información.
