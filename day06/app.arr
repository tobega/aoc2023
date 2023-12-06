import file("input.arr") as I
include tables

fun read-numbers(line):
  string-split-all(string-substring(line, 10, string-length(line)), ' ')
    .map(string-to-number)
    .remove(none)
    .map(lam(opt): opt.or-else(0) end)
end

records = [table-from-columns:
  {"time"; read-numbers(I.raw.get(0))},
  {"distance"; read-numbers(I.raw.get(1))}
]

fun ways-to-beat(time, distance):
  fun find-first(hold-time):
    ask:
      | (hold-time * (time - hold-time)) > distance then: (time - (2 * hold-time)) + 1
      | (2 * (hold-time + 1)) <= time then: find-first(hold-time + 1)
      | otherwise: 0
    end
  end
  find-first(1)
where:
  ways-to-beat(7, 9) is 4
end

fun part1():
  beatings = extend records using time, distance:
    beatings: ways-to-beat(time, distance)
  end
  (extract beatings from beatings end).foldl(_ * _, 1)
end

check: part1() is 1660968 end

fun read-as-one-number(line):
  string-to-number(
    string-explode(string-substring(line, 10, string-length(line)))
    .remove(" ")
    .foldr(string-append, "")
  ).or-else(-1)
where:
  read-as-one-number("Time:      7  15   30") is 71530
  read-as-one-number("Distance:  9  40  200") is 940200
end

fun ways-to-beat-binary(time, distance):
  fun find-first(lose, win):
    half = num-truncate((lose + win) / 2)
    ask:
      | half == lose then: (time - (2 * win)) + 1
      | (half * (time - half)) > distance then: find-first(lose, half)
      | otherwise: find-first(half, win)
    end
  end
  half = num-truncate(time / 2)
  ask:
    | (half * (time - half)) <= distance then: 0
    | otherwise: find-first(0, half)
  end
where:
  ways-to-beat-binary(7, 9) is 4
  ways-to-beat-binary(71530, 940200) is 71503
end

fun part2():
  ways-to-beat(read-as-one-number(I.raw.get(0)), read-as-one-number(I.raw.get(1)))
end

check: part2() is 26499773 end
