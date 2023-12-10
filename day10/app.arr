import file("input.arr") as I
import lists as L
import either as EI

fun line-to-pipes(line):
  fun symbol-to-pipe(symbol):
    ask:
      | symbol == '.' then: empty
      | symbol == '|' then: [list: 'N', 'S']
      | symbol == '-' then: [list: 'E', 'W']
      | symbol == 'L' then: [list: 'E', 'N']
      | symbol == 'J' then: [list: 'N', 'W']
      | symbol == '7' then: [list: 'S', 'W']
      | symbol == 'F' then: [list: 'E', 'S']
      | symbol == 'S' then: [list: 'E', 'W', 'N', 'S']
    end
  end
  array-from-list(string-explode(string-append('.', string-append(line, '.'))).map(symbol-to-pipe))
end

empty-line = [list: line-to-pipes(string-repeat('.', 2 + string-length(I.raw.first)))]
grid = array-from-list(empty-line.append(I.raw.map(line-to-pipes).append(empty-line)))

pos-S = L.fold-while(lam(p, n):
  if n == -1: EI.left(p + 1)
  else: EI.right({p; n + 1})
  end
end, 1, I.raw.map(string-index-of(_, 'S')))

data Squirrel: squirrel(edge, pos) end

fun go(direction, sq):
  ask:
    | direction == 'N' then: squirrel('S', {sq.pos.{0} - 1; sq.pos.{1}})
    | direction == 'S' then: squirrel('N', {sq.pos.{0} + 1; sq.pos.{1}})
    | direction == 'E' then: squirrel('W', {sq.pos.{0}; sq.pos.{1} + 1})
    | direction == 'W' then: squirrel('E', {sq.pos.{0}; sq.pos.{1} - 1})
  end
end

fun move(sq):
  dir = grid.get-now(sq.pos.{0}).get-now(sq.pos.{1}).filter(lam(d): not(d == sq.edge) end).first
  go(dir, sq)
end

fun is-valid-entry(sq):
  pipe = grid.get-now(sq.pos.{0}).get-now(sq.pos.{1})
  pipe.member(sq.edge)
end

fun find-loop-size(steps, sqs):
  if not(sqs.length() == list-to-set(sqs.map(lam(sq): sq.pos end)).size()):
    steps
  else:
    find-loop-size(steps + 1, sqs.map(move).filter(is-valid-entry))
  end
end

fun part1():
  sq = squirrel('', pos-S)
  find-loop-size(1, [list: go('N', sq), go('S', sq), go('E', sq), go('W', sq)].filter(is-valid-entry))
end

check: part1() is 7093 end
