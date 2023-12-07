import file("input.arr") as I
include tables
include math
import lists as L

empty-hand-table = table: hand, bid end

fun add-line-as-row(line, t):
  parts = string-split(line, " ")
  t.add-row(t.row(parts.get(0), string-to-number(parts.get(1)).or-else(0)))
end

hands = I.raw.foldl(add-line-as-row, empty-hand-table)

fun calculate-clumpiness(hand):
  block:
    cards = "23456789TJQKA"
    values = array-of(0, 13)
    string-explode(hand).map(lam(c):
      v = string-index-of(cards, c)
      values.set-now(v, values.get-now(v) + 1) end)
    values.to-list-now().foldl(lam(v,c): c + (v * (v - 1)) end, 0)
  end
where:
  calculate-clumpiness("23456") < calculate-clumpiness("22456") is true
  calculate-clumpiness("22456") < calculate-clumpiness("22455") is true
  calculate-clumpiness("22455") < calculate-clumpiness("22234") is true
  calculate-clumpiness("22234") < calculate-clumpiness("22233") is true
  calculate-clumpiness("22255") < calculate-clumpiness("22224") is true
  calculate-clumpiness("22225") < calculate-clumpiness("22222") is true
end

fun collate-cards(hand):
  cards = "23456789TJQKA"
  collated = "abcdefghijklm"
  string-explode(hand).map(lam(c): string-char-at(collated, string-index-of(cards, c)) end)
    .foldr(string-append, "")
end

fun winnings(hand-table, clumper, collater):
  clumped = extend hand-table using hand:
    clumpiness: clumper(hand),
    collated: collater(hand)
  end
  ordered = order clumped:
    clumpiness ascending,
    collated ascending
  end
  sum(map_n(_ * _, 1, (extract bid from ordered end)))
where:
  winnings(table: hand, bid
    row: "32T3K", 765
    row: "T55J5", 684
    row: "KK677", 28
    row: "KTJJT", 220
    row: "QQQJA", 483
  end, calculate-clumpiness, collate-cards) is 6440
end

fun part1():
  winnings(hands, calculate-clumpiness, collate-cards)
end

check: part1() is 246409899 end

fun calculate-clumpiness-joker(hand):
  block:
    cards = "J23456789TQKA"
    values = array-of(0, 13)
    string-explode(hand).map(lam(c):
      v = string-index-of(cards, c)
      values.set-now(v, values.get-now(v) + 1) end)
    jokers = values.get-now(0)
    values.set-now(0, 0)
    max-n = L.fold_n(lam(n,mxn,v): if v > values.get-now(mxn): n else: mxn end end, 0, 0, values.to-list-now())
    values.set-now(max-n, values.get-now(max-n) + jokers)
    values.to-list-now().foldl(lam(v,c): c + (v * (v - 1)) end, 0)
  end
where:
  values = array-from-list([list: 0, 0, 15, 0])
  L.fold_n(lam(n, mxn, v): if v > values.get-now(mxn): n else: mxn end end, 0, 0, values.to-list-now()) is 2
  calculate-clumpiness-joker("23456") is 0
  calculate-clumpiness-joker("22456") is 2
  calculate-clumpiness-joker("22455") is 4
  calculate-clumpiness-joker("22234") is 6
  calculate-clumpiness-joker("22255") is 8
  calculate-clumpiness-joker("22225") is 12
  calculate-clumpiness-joker("22222") is 20

  calculate-clumpiness-joker("2J456") is 2
  calculate-clumpiness-joker("2245J") is 6
  calculate-clumpiness-joker("J2234") is 6
  calculate-clumpiness-joker("2J233") is 8
  calculate-clumpiness-joker("22J24") is 12
  calculate-clumpiness-joker("2222J") is 20
end

fun collate-cards-joker(hand):
  cards = "J23456789TQKA"
  collated = "abcdefghijklm"
  string-explode(hand).map(lam(c): string-char-at(collated, string-index-of(cards, c)) end)
    .foldr(string-append, "")
end

fun part2():
  winnings(hands, calculate-clumpiness-joker, collate-cards-joker)
end

check: part2() is 244848487 end
