import std/[sets, strutils]

#-- Add whitespace
proc blank*(num: int): string {.inline.} =
  result = (" ").repeat(num)

#-- Compare two sequences
proc areSeqEqual*(seq1, seq2: seq[string]): bool {.inline.} =
  result = toHashSet(seq1) == toHashSet(seq2)

#-- Get the longest word in an array and its length
proc getLongestWord*(words: seq[string] = @[]): string =
  var longestWord = words[0]

  for word in words:
    if word.len > longestWord.len:
      longestWord = word
  return longestWord

#-- Wrap text if it is too long
proc wrapText*(text: string, width, firstMargin, leftMargin: int): seq[string] =
  var line: seq[string]
  var currentLine: string = ""
  var isFirstLine: bool = true

  for word in text.split(" "):
    if (currentLine.len + word.len + 1) > width:
      line.add(currentLine)
      currentLine = blank(leftMargin) & word
    else:
      if currentLine.len > 0:
        currentLine &= " "
      if isFirstLine:
        currentLine = blank(firstMargin)
        isFirstLine = false
      currentLine &= word

  if (currentLine.len > 0):
    line.add(currentLine)
  return line
