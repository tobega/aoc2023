import file("input.arr") as I
import math as M

fun first-last-digits(s :: String):
  digits = string-explode(s).map(lam(c): string-to-number(c).or-else(-1) end).remove(-1)
  (digits.get(0) * 10) + digits.last()
where:
  first-last-digits("1abc2") is 12
  first-last-digits("pqr3stu8vwx") is 38
  first-last-digits("a1b2c3d4e5f") is 15
  first-last-digits("treb7uchet") is 77
end

fun part1():
  M.sum(I.raw.map(first-last-digits))
end

check:
  part1() is 55108
end