import std/[sets, strutils]
import types

#-- Add whitespace
proc blank*(num: int): string {.inline.} =
  result = (" ").repeat(num)

#-- Compare two sequences
proc areSeqEqual*(seq1, seq2: seq[string]): bool {.inline.} =
  result = toHashSet(seq1) == toHashSet(seq2)

#-- Get the longest word in an array and its length
proc getLongestWord*(words: openArray[string]): string =
  var longestWord = words[0]

  for word in words:
    if word.len > longestWord.len:
      longestWord = word
  return longestWord

#-- Wrap text if it is too long
proc wrapText*(text: string, width, firstMargin, leftMargin: int): seq[string] =
  var line: seq[string]
  var currentLine = blank(firstMargin)
  var isFirstLine = true

  # Iterate over each word in the input text
  for word in text.split(" "):
    if (currentLine.len + word.len + 1) > width:
      line.add(currentLine)
      currentLine = blank(leftMargin) & word
    else:
      if not isFirstLine:
        currentLine &= " "
      else:
        isFirstLine = false
      currentLine &= word
  # Add the final line to the lines sequence
  if (currentLine.len > 0):
    line.add(currentLine)
  return line

#-- Data validation
proc hasDuplicates(s: seq[string]): bool =
  for i in 0..<s.high:
    for j in i + 1..<s.len:
      if s[i] == s[j]:
        return true
  return false

proc validateCmdosCmd*(cmd: CmdosCmd): bool =
  var namesCount = 0
  var list: seq[string]

  for opt in cmd.opts:
    if opt.names == cmd.names:
      namesCount += 1
      if namesCount > 1: return false
  for opt in cmd.opts:
    list.add(opt.names)
  return not hasDuplicates(list)

proc validateCmdos*(cmd: static Cmdos): bool =
  var namesCount = 0
  for cmds in cmd.cmds:
    if "" in cmds.names:
      namesCount += 1
      if namesCount > 1: return false
  return true

