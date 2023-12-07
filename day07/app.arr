import file("input.arr") as I
include tables
include math

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

fun winnings(hand-table):
  clumped = extend hand-table using hand:
    clumpiness: calculate-clumpiness(hand),
    collated: collate-cards(hand)
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
  end) is 6440
end

fun part1():
  winnings(hands)
end

check: part1() is 246409899 end
