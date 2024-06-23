> [!TIP]
> Use `Google Translate` to read this file in your native language.

# Cmdos
Cmdos es un modulo para Nim que proporciona una forma sencilla de procesar argumentos de línea de comandos.

## Uso

1. Importa el módulo Cmdos.
```nim
import Cmdos/cmdos
```

2. Define tus argumentos y sus valores predeterminados.
```nim
var example = Cmdos(
  arguments: @["--name", "--age"],
  values: @["John Doe", "30"],
)
```

3. Extrae los valores analizados.
```nim
var pairs = extractPairs(example.processArgsInputs())
```

4. Y utiliza los valores en tu aplicación.
```nim
echo "Nombre: ", pairs[0]
echo "Edad: ", pairs[1]
```

### Ejemplo
Aquí hay un ejemplo completo que demuestra cómo usar Cmdos:

```nim
import os
import Cmdos/cmdos

var example = Cmdos(
  arguments: @["--name", "--age"],
  values: @["John Doe", "30"],
)

if paramCount() > 0:
  case paramStr(1):
    of "--name":
      echo "Nombre: ", extractPairs(example.processArgsInputs())[0]
    of "--age":
      echo "Edad: ", extractPairs(example.processArgsInputs())[1]
```

Ejecuta el ejemplo con argumentos de línea de comandos:
```sh
nim c -r example.nim --name "Jane Doe" --age 25
```

## Licencia
Cmdos está bajo la licencia MIT. Consulta el archivo `LICENSE` para obtener más información.
