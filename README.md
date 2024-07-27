> [!TIP]
> Use `Google Translate` to read this file in your native language.

# Cmdos
Cmdos es un pequeño módulo para [`Nim`](https://nim-lang.org/) que facilita el procesamiento de argumentos de línea de comandos y la generación automática de mensajes de ayuda.

## Características

### Ventajas:
- Es muy fácil de implementar.
- Permite recibir múltiples entradas para un mismo argumento.
- Provee un generador de mensajes de ayuda que se crea en tiempo de compilación.

### Desventajas:
- No permite argumentos solitarios; todos los argumentos deben recibir un valor por defecto.
- No admite delimitadores para separar valores (por ejemplo: `-c=Red,Blue`, `-c=:Red:Blue`), solo espacios en blanco (`-a Red Blue`).
- No admite llamar un mismo argumento múltiples veces; es decir, `-c Red -c Blue` ignorará la segunda llamada del argumento.

## Instalación
Para instalar Cmdos, sigue los siguiente pasos:

```sh
nimble install https://github.com/farias-hecdin/Cmdos.git
```

## Uso
1. Primero, importa el módulo `pkg/Cmdos`, y el modulo `std/os` para capturar los argumentos de entrada.

```nim
import pkg/cmdos
import std/[os]
```

2. Define tus argumentos y sus valores predeterminados. Aquí tienes un ejemplo de cómo definir un comando con varios argumentos:

```nim
# Command number one
const Add = CmdosCmd(
  names: @["add"],
  desc: "Adds a new book to the library.",
  args: @[
    CmdosArg(
      names: @["-t", "--title"],
      inputs: @["The Great Book"],
      desc: "The title of the book.",
      placeholder: "<string>",
    ),
    CmdosArg(
      names: @["-a", "--author"],
      inputs: @["John Doe", "Susan Dek"],
      desc: "The author of the book.",
      placeholder: "<string>...",
    ),
    CmdosArg(
      names: @["-p", "--pages"],
      inputs: @["800"],
      desc: "The number of pages in the book.",
      placeholder: "<int>",
    ),
  ],
)
```

3. Procesa los argumentos y extrae los valores analizados. Aquí tienes un ejemplo de cómo hacerlo:

```nim
# Init app
proc run() = (
  if paramCount() > 0:
    case paramStr(1):
      of "add":
        var values = processArgs(Add)
        echo values
      else:
        echo "Invalid option"
)
```

4. Una vez que los argumentos han sido procesados, puedes utilizarlos en tu aplicación.

Puedes ejecutar el ejemplo anterior de la siguiente manera:

```sh
nim c example.nim
```

```sh
./example add --title "Lorem Ipsum" --author "Jane Doe" --page 125
```

Aquí esta el [ejemplo](./test/example.nim) completo que demuestra cómo usar `Cmdos`.

## Licencia
Cmdos está bajo la licencia MIT. Consulta el archivo `LICENSE` para obtener más información.


