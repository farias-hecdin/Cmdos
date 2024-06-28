> [!TIP]
> Use `Google Translate` to read this file in your native language.

# Cmdos
Cmdos es un pequeño modulo para [`Nim`](https://nim-lang.org/) que proporciona una forma sencilla de procesar argumentos de línea de comandos.

## Instalación
Para instalar Cmdos, sigue el siguiente paso:
```sh
nimble install https://github.com/farias-hecdin/Cmdos.git
```

## Uso

1. Importa el módulo Cmdos.
```nim
import cmdos
```

2. Define tus argumentos y sus valores predeterminados.
```nim
var person = Cmdos(
  args: @[
    Arg(short: "-n", long: "--name", default: "John Doe"),
    Arg(short: "-a", long: "--age", default: "30"),
  ],
  opts: @["My name is '", "' and i am '", "' years old."]
)
```

3. Procesa los argumentos y extrae los valores analizados.
```nim
var input = processArgs(person, false) # The value "true" omits the first parameter.
var (arg, value) = extractPairs(input)
```

4. Y utiliza los valores en tu aplicación.
```nim
var opts = person.opts

echo "1. Input: ", input
echo "2. Args: ", arg
echo "3. Values: ", value

echo opts[0], value[0], opts[1], value[1], opts[2]
```

Ejecuta el ejemplo con argumentos de línea de comandos:
```sh
nim c -r example.nim --name "Jane Doe" --age 25
```

Aquí hay otro [ejemplo](./test/example_1.nim) completo que demuestra cómo usar Cmdos.

## Licencia
Cmdos está bajo la licencia MIT. Consulta el archivo `LICENSE` para obtener más información.
