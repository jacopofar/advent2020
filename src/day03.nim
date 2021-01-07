import sets
import strformat

type Coord = tuple[row: int, col: int]

iterator toboga_pos(num_columns: int, num_rows: int, right_step: int, down_step: int): Coord =
  var (c, r) = (0, 0)
  while r < num_rows:
    yield (r, c)
    r += down_step
    c = (c + right_step) mod num_columns


proc count_trees(trees_coords: HashSet[Coord], num_cols: int, num_rows: int, right_step: int, down_step: int): int =
  for row, col in toboga_pos(num_cols, num_rows, right_step, down_step):
    if trees_coords.contains((row, col)):
      result += 1


proc main() =
  var trees_coords = initHashSet[Coord]()
  var linenum = 0
  var num_cols: int

  for line in lines("day03.txt"):
    # this runs for all the lines but is the same value...
    num_cols = line.len
    for i, c in line:
      if c == '#':
        trees_coords.incl((linenum, i))
    linenum += 1

  var found_trees = count_trees(trees_coords, num_cols, linenum, 3, 1)
  echo &"PART 1: there were {found_trees} trees in the path"

  const slopes = [
    (1, 1),
    (3, 1),
    (5, 1),
    (7, 1),
    (1, 2),
    ]
  var prod = 1
  for (right, down) in slopes:
    found_trees = count_trees(trees_coords, num_cols, linenum, right, down)
    echo &"there were {found_trees} trees in the path for right={right}, down={down}"
    prod *= found_trees
  echo &"PART 2: total product {prod}"

when isMainModule:
  main()
