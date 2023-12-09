import file("input.arr") as I

fun rec-diff(vs, ds):
  if is-empty(vs.rest):
    {vs.first;ds}
  else:
    rec-diff(vs.rest, link(vs.rest.first - vs.first, ds))
  end
where:
  rec-diff([list: 1, 2, 3], empty) is {3; [list: 1, 1]}
end

fun derive-next(seq):
  fun add-ends(diffs, ends):
    if diffs.all(_ == 0):
      ends
    else:
      d-end = rec-diff(diffs, empty)
      add-ends(d-end.{1}.reverse(), link(d-end.{0}, ends))
    end
  end
  add-ends(seq, empty).foldl(_ + _, 0)
end

fun part1():
  I.raw.map(lam(line): string-split-all(line, " ").map(lam(v): string-to-number(v).or-else(0) end) end)
  .map(derive-next)
  .foldl(_ + _, 0)
end

check: part1() is 1772145754 end

fun derive-first(seq):
  fun add-firsts(diffs, firsts):
    if diffs.all(_ == 0):
      firsts
    else:
      d-end = rec-diff(diffs, empty)
      add-firsts(d-end.{1}.reverse(), link(diffs.first, firsts))
    end
  end
  add-firsts(seq, empty).foldl(_ - _, 0)
end

fun part2():
  I.raw.map(lam(line): string-split-all(line, " ").map(lam(v): string-to-number(v).or-else(0) end) end)
  .map(derive-first)
  .foldl(_ + _, 0)
end

check: part2() is 867 end
