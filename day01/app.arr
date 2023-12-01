import file("input.arr") as I
import math as M

fun first-last-digits(s :: String):
  digits = string-explode(s).map(lam(c): string-to-number(c).or-else(-1) end).remove(-1)
  (digits.first * 10) + digits.last()
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

fun freestyle-digits(line :: String):
  fun starts-with(s :: String, word :: String) -> Boolean:
    (string-length(s) >= string-length(word)) and (string-substring(s, 0, string-length(word)) == word)
  end
  fun written-digit(s :: String) -> Option<Number>:
    if starts-with(s, "zero"):
      some(0)
    else if starts-with(s, "one"):
      some(1)
    else if starts-with(s, "two"):
      some(2)
    else if starts-with(s, "three"):
      some(3)
    else if starts-with(s, "four"):
      some(4)
    else if starts-with(s, "five"):
      some(5)
    else if starts-with(s, "six"):
      some(6)
    else if starts-with(s, "seven"):
      some(7)
    else if starts-with(s, "eight"):
      some(8)
    else if starts-with(s, "nine"):
      some(9)
    else:
      none
    end
  end
  fun starts-with-digit(s :: String):
    cases (Option) string-to-number(string-substring(s, 0, 1)):
      | some(n) => some(n)
      | none => written-digit(s)
    end
  end
  fun find-digits(s :: String, d):
    if string-length(s) == 0:
      d
    else:
      cases (Option) starts-with-digit(s):
        | some(n) => find-digits(string-substring(s, 1, string-length(s)), link(n, d))
        | none => find-digits(string-substring(s, 1, string-length(s)), d)
      end
    end
  end
  reverse-digits = find-digits(line, [list:])
  (reverse-digits.last() * 10) + reverse-digits.first
where:
  freestyle-digits("two1nine") is 29
  freestyle-digits("eightwo") is 82
  freestyle-digits("zoneight234") is 14
  freestyle-digits("7pqrstsixteen") is 76
end

fun part2():
  M.sum(I.raw.map(freestyle-digits))
end

check:
  part2() is 56324
end
