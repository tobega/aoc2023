import file("input.arr") as I

data CubeSet: cube-set(red :: Number, green :: Number, blue :: Number) end

fun cube-set-from-string(s :: String) -> CubeSet:
  fun set-cube-count(elt, acc):
    part = string-split(elt, " ")
    if part.get(1) == "red": cube-set(string-to-number(part.get(0)).or-else(none), acc.green, acc.blue)
    else if part.get(1) == "green": cube-set(acc.red, string-to-number(part.get(0)).or-else(none), acc.blue)
    else if part.get(1) == "blue": cube-set(acc.red, acc.green, string-to-number(part.get(0)).or-else(none))
    else: raise(s)
    end
  end
  string-split-all(s, ", ").foldl(set-cube-count, cube-set(0, 0, 0))
where:
  cube-set-from-string("1 red, 2 blue, 3 green") is cube-set(1, 3, 2)
  cube-set-from-string("2 blue, 3 green, 1 red") is cube-set(1, 3, 2)
  cube-set-from-string("3 green, 1 red") is cube-set(1, 3, 0)
  cube-set-from-string("3 green, 12 blue") is cube-set(0, 3, 12)
end

data Game: game(id, cube-sets) end

fun game-from-line(line :: String) -> Game:
  parts = string-split(line, ": ")
  game(string-to-number(string-substring(parts.get(0), 5, string-length(parts.get(0)))).or-else(none),
    string-split-all(parts.get(1), "; ").map(cube-set-from-string))
where:
  game-from-line("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green") is game(1, [list: cube-set(4,0,3), cube-set(1,2,6), cube-set(0,2,0)])
end

fun could-be-from(cube-sets, all-cubes):
  is-empty(cube-sets.filter(lam(c): (c.red > all-cubes.red) or (c.green > all-cubes.green) or (c.blue > all-cubes.blue) end))
end

fun part1():
  I.raw.map(game-from-line)
    .filter(lam(g): could-be-from(g.cube-sets, cube-set(12, 13, 14)) end)
    .map(lam(g): g.id end)
    .foldl(_ + _, 0)
end

check: part1() is 3035 end