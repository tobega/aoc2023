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

fun steps-between(start, done, i):
  if done(start):
    0
  else:
    next = if string-char-at(instructions, i) == "L":
      choice-dict.get-value(start).left
    else:
      choice-dict.get-value(start).right
    end
    1 + steps-between(next, done, num-modulo(i + 1, string-length(instructions)))
  end
end

fun part1():
  steps-between("AAA", _ == "ZZZ", 0)
end

check: part1() is 22357 end

fun ends-with(name, c):
  string-char-at(name, 2) == c
end

fun gcd(a, b):
  r = num-modulo(a, b)
  if r == 0:
    b
  else:
    gcd(b, r)
  end
end

fun lcm-factors(a, factors):
  fun check-factors(b, rest, checked):
    cases(List) rest:
      | empty => link(b, checked)
      | link(f, fs) => block:
        factor = gcd(f, b)
        check-factors(b / factor, fs, link(f / factor, link(factor, checked)))
      end
    end
  end
  check-factors(a, factors, empty)
end

fun part2():
  # assuming each starting point will loop regularly.
  choice-dict.keys().to-list().filter(ends-with(_, "A"))
  .map(steps-between(_, ends-with(_, "Z"), 0))
  .foldl(lcm-factors, [list: 1])
  .foldl(_ * _, 1)
end

check: part2() is 10371555451871 end