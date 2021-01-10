import re
import strutils
import tables

type Passport = TableRef[string, string]

const MANDATORY_KEYS = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
const VALID_EYECOLORS = @["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

iterator read_passports(): Passport =
  var passport = newTable[string, string]()
  for line in lines("day04.txt"):
    if line == "":
      yield passport
      passport = newTable[string, string]()
    else:
      for kv in line.split(" "):
        var parts = kv.split(":")
        passport[parts[0]] = parts[1]
  # the last one, depends on the last newline
  if passport.len > 0:
    yield passport

proc is_passport_valid1(p: Passport): bool =
  for k in MANDATORY_KEYS:
    if not p.hasKey(k):
      return false
  return true

proc is_passport_valid2(p: Passport): bool =
  # check that previous rules apply and fields are there
  if not is_passport_valid1(p):
    return false
  try:
    # byr (Birth Year) - four digits; at least 1920 and at most 2002.
    var byr = parseInt(p["byr"])
    if byr > 2002 or byr < 1920:
      return false
    # iyr (Issue Year) - four digits; at least 2010 and at most 2020.
    var iyr = parseInt(p["iyr"])
    if iyr > 2020 or iyr < 2010:
      return false
    # eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
    var eyr = parseInt(p["eyr"])
    if eyr > 2030 or eyr < 2020:
      return false
    # hgt (Height) - a number followed by either cm or in:
    #     If cm, the number must be at least 150 and at most 193.
    #     If in, the number must be at least 59 and at most 76.
    var hunit = p["hgt"][^2 .. ^1]
    var hvalue = parseInt(p["hgt"][0 .. ^3])
    if hunit == "cm":
      if hvalue > 193 or hvalue < 150:
        return false
    if hunit == "in":
      if hvalue > 76 or hvalue < 59:
        return false
    # hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
    if not match(p["hcl"], re"^#[\da-f]{6}$"):
      return false
    # ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
    if not (p["ecl"] in VALID_EYECOLORS):
      return false
    # pid (Passport ID) - a nine-digit number, including leading zeroes.
    if not match(p["pid"], re"^[\d]{9}$"):
      return false
    # cid (Country ID) - ignored, missing or not.
    return true
  except ValueError:
    return false


proc main() =
  var (total, valid1, valid2) = (0, 0, 0)
  for p in read_passports():
    total += 1
    if is_passport_valid1(p):
      valid1 += 1
    if is_passport_valid2(p):
      valid2 += 1
  echo "Total passports: ", total
  echo "Part 1, valid passports: ", valid1
  echo "Part 2, valid passports: ", valid2

when isMainModule:
  main()
