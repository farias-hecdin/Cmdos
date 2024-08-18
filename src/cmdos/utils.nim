import std/[sets, strutils]

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

