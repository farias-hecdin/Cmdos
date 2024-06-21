import os

type Cmdos* = object
  arguments*: seq[string]
  values*: seq[string]

#-- Fusionar dos secuencias de argumentos (args, inputs)
proc mergeArgs(self: Cmdos, A, B: seq[string]): seq[string] =
  var values: seq[string]

  for i in countup(0, A.len - 1, 2):
    let arg = A[i]
    let val = A[i + 1]

    if arg in self.arguments:
      var found = false
      for j in countup(0, B.len - 1, 2):
        if B[j] == arg:
          values.add(B[j])
          values.add(B[j + 1])
          found = true
          break

      if not found:
        values.add(arg)
        values.add(val)

  return values

proc g_processArgsInputs*(self: Cmdos): seq[string] =
  var number = paramCount()
  var inputs, default, data: seq[string]

  # Si hay argumentos, almacenarlos en la secuencia de inputs
  if number > 0:
    for i in 1..number:
      add(inputs, paramStr(i))
  else:
    return

  # Verificar si el número de inputs es par (pares clave-valor)
  if inputs.len %% 2 != 0: return

  # Crear una secuencia de argumentos predeterminados y valores
  for i in 1..(self.values).len:
    add(default, self.arguments[i - 1])
    add(default, self.values[i - 1])

  # Fusionar los argumentos predeterminados con los argumentos de entrada
  add(data, mergeArgs(self, default, inputs))
  return data

#-- Extraer el valor de los argumentos
proc g_extractPairs*(values: seq[string]): seq[string] =
  var pairs: seq[string]

  for i in 0..(values).len:
    if i %% 2 != 0:
      add(pairs, values[i])
  return pairs

#-- Pruebas
proc test() =
  var pairs: seq[string]
  var example1 = Cmdos(
    arguments: @["--1", "--a", "--b"],
    values: @["Ana", "Maria", "30"],
  )
  var example2 = Cmdos(
    arguments: @["--2", "--a", "--b"],
    values: @["Juan", "Perez", "25"],
  )

  if paramCount() > 0:
    case paramStr(1):
      of "--1":
        pairs = g_extractPairs(example1.g_processArgsInputs())
      of "--2":
        pairs = g_extractPairs(example2.g_processArgsInputs())
  echo pairs, "\n"

test()
