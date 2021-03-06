import intsets
import streams
from strutils import parseInt

proc main() =
  var nums = initIntSet()

  for line in lines("day01.txt"):
    nums.incl(parseInt(line))

  echo "part one:"
  for a in nums:
    for b in nums:
      if a + b == 2020:
        echo a, " ", b, " ", a * b

  echo "part two"
  for a in nums:
    for b in nums:
      for c in nums:
        if a + b + c == 2020:
          echo a, " ", b, " ", c, " ", a * b * c

when isMainModule:
  main()
