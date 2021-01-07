import strformat
import streams
import strutils
import re

proc main() =
  let strm = newFileStream("day02.txt", fmRead)
  defer: strm.close()

  var line = ""
  var matches: array[4, string]
  var valid1 = 0
  var valid2 = 0

  while strm.readLine(line):
    doAssert match(line, re"(\d+)-(\d+) (\w): (\w+)", matches, 0)
    let start_pos = parseInt(matches[0])
    let end_pos = parseInt(matches[1])

    let found:int = matches[3].count(matches[2])
    if found >= start_pos and found <= end_pos:
      valid1 += 1
    # indexes in the input are 1-based
    if $matches[3][start_pos - 1] == matches[2] xor $matches[3][end_pos - 1] == matches[2]:
      valid2 += 1

  echo &" Part 1: found {valid1} matches"
  echo &" Part 2: found {valid2} matches"

when isMainModule:
  main()
