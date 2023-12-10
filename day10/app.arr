import file("input.arr") as I
import lists as L
import either as EI

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

fun line-to-pipes(line):
  array-from-list(string-explode(string-append('.', string-append(line, '.'))).map(symbol-to-pipe))
end

empty-line = [list: line-to-pipes(string-repeat('.', string-length(I.raw.first)))]
grid = array-from-list(empty-line.append(I.raw.map(line-to-pipes).append(empty-line)))

pos-S = L.fold-while(lam(p, n):
  if n == -1: EI.left(p + 1)
  else: EI.right({p; n + 1})
  end
end, 1, I.raw.map(string-index-of(_, 'S')))

data Squirrel: squirrel(start, edge, pos) end

fun go(direction, sq):
  ask:
    | direction == 'N' then: squirrel(sq.start, 'S', {sq.pos.{0} - 1; sq.pos.{1}})
    | direction == 'S' then: squirrel(sq.start, 'N', {sq.pos.{0} + 1; sq.pos.{1}})
    | direction == 'E' then: squirrel(sq.start, 'W', {sq.pos.{0}; sq.pos.{1} + 1})
    | direction == 'W' then: squirrel(sq.start, 'E', {sq.pos.{0}; sq.pos.{1} - 1})
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

fun find-loop(steps, sqs):
  if not(sqs.length() == list-to-set(sqs.map(lam(sq): sq.pos end)).size()):
    met-sq = L.fold-while(lam(seen, sq):
      if seen.member(sq.pos):
        block:
          starts = sqs.filter(lam(s): s.pos == sq.pos end).map(lam(s): s.start end)
          grid.get-now(pos-S.{0}).set-now(pos-S.{1}, starts)
          EI.right(sq)
        end
      else:
        EI.left(link(sq.pos, seen))
      end
    end, empty, sqs)
    {steps; met-sq}
  else:
    find-loop(steps + 1, sqs.map(move).filter(is-valid-entry))
  end
end

found-loop = block:
  find-loop(1, [list: go('N', squirrel('N', '', pos-S)),
    go('S', squirrel('S', '', pos-S)),
    go('E', squirrel('E', '', pos-S)),
    go('W', squirrel('W', '', pos-S))]
  .filter(is-valid-entry))
end

fun part1():
  found-loop.{0}
end

check: part1() is 7093 end

fun mark-loop(start-sq):
  loop-marks = build-array(lam(n): array-of(empty, grid.get-now(0).length()) end, grid.length())
  fun go-around(sq):
    block:
      grid-value = grid.get-now(sq.pos.{0}).get-now(sq.pos.{1})
      loop-marks.get-now(sq.pos.{0}).set-now(sq.pos.{1}, grid-value)
      if sq.pos == start-sq.pos:
        none
      else:
        go-around(move(sq))
      end
    end
  end
  block:
    go-around(move(start-sq))
    loop-marks
  end
end

fun part2():
  fun count-inside(a):
    a.to-list-now().foldl(lam(l, s):
      if l == empty:
        if s.{0}:
          {s.{0}; s.{1} + 1}
        else:
          s
        end
      else if not(l == empty):
        {
          if l.member('N'): not(s.{0}) else: s.{0} end;
          s.{1}
        }
      end
    end, {false; 0}).{1}
  end
  mark-loop(found-loop.{1}).to-list-now().map(count-inside).foldl(_ + _, 0)
end

check: part2() is 407 end
