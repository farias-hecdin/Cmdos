var skipFirst: bool

#-- Fusionar dos secuencias de argumentos (args, inputs)
proc mergeArgsInputs(self: CmdosArg, A, B: seq[string]): seq[string] =
  var values: seq[string]
  var start = 0

  if skipFirst == true:
    start = 1

  for arg in self.args:
    var found = false
    for j in countup(start, B.len - 1, 2):
      if B[j] == arg.long or B[j] == arg.short:
        values.add(B[j])
        values.add(B[j + 1])
        found = true
        break
    if not found:
      values.add(arg.long)
      values.add(arg.default)
  return values

#-- Procesar los argumentos de entrada
proc processArgs*(self: CmdosArg, ignoreFirst: bool = false, cliArgs: seq[string] = commandLineParams()): seq[string] =
  var inputs, default, data: seq[string]
  skipFirst = ignoreFirst

  # Verificar si el número de inputs tiene pares clave-valor
  add(inputs, cliArgs)
  if (inputs.len %% 2 == 0) == skipFirst:
    raise newException(ValueError, "Invalid argument.")

  # Crear una secuencia de argumentos predeterminados y valores
  for i in 1..(self.args).len:
    add(default, self.args[i - 1].long)
    add(default, self.args[i - 1].short)
    add(default, self.args[i - 1].default)

  # Fusionar los argumentos predeterminados con los argumentos de entrada
  add(data, mergeArgsInputs(self, default, inputs))
  return data

#-- Extraer el valor de los argumentos
proc extractPairs*(data: seq[string]): (seq[string], seq[string]) =
  var args, values: seq[string]

  for i in 1..(data).len:
    if i %% 2 == 0:
      add(values, data[i - 1])
    else:
      add(args, data[i - 1])
  return (args, values)

