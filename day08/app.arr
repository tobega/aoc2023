import file("input.arr") as I
include string-dict

data Choice: choice(left, right) end

fun parse-node-line(line):
  parts = string-split(line, " = ")
  choices = string-split(string-substring(parts.get(1), 1, string-length(parts.get(1)) - 1), ", ")
  {parts.get(0); choice(choices.get(0), choices.get(1))}
end

instructions = I.raw.get(0)
choice-dict = I.raw.drop(2).map(parse-node-line).foldl(lam(n, d): d.set(n.{0}, n.{1}) end, [string-dict:])

fun steps-between(start, to, i):
  if start == to:
    0
  else:
    next = if string-char-at(instructions, i) == "L":
      choice-dict.get-value(start).left
    else:
      choice-dict.get-value(start).right
    end
    1 + steps-between(next, to, num-modulo(i + 1, string-length(instructions)))
  end
end

fun part1():
  steps-between("AAA", "ZZZ", 0)
end

check: part1() is 22357 end
