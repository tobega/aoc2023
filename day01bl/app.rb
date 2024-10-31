require 'bud'

class App
  include Bud

  Digit_names = 'one|two|three|four|five|six|seven|eight|nine'

  def name_to_digit(name)
    case name
    when 'one'
      '1'
    when 'two'
      '2'
    when 'three'
      '3'
    when 'four'
      '4'
    when 'five'
      '5'
    when 'six'
      '6'
    when 'seven'
      '7'
    when 'eight'
      '8'
    when 'nine'
      '9'
    else
      name
    end
  end

  def initialize(part, opts={})
    super opts
    @part = part
  end
  
  state do
    table   :lines, [:idx, :line]
    table   :first_digit, [:idx, :digit]
    table   :last_digit, [:idx, :digit]
    table   :numbers, [:idx, :value]
  end

  bloom :parse do
    first_digit <= lines {|l| [l.idx, l.line[if @part == 1
      /[0-9]/
    else
      Regexp.new('[0-9]|' + Digit_names)
    end]]}
    last_digit <= lines {|l| [l.idx, l.line.reverse[if @part == 1
      /[0-9]/
    else
      Regexp.new('[0-9]|' + Digit_names.reverse)
    end].reverse]}
  end

  bloom :combine do
    numbers <= (first_digit * last_digit).pairs(:idx => :idx) {|f, l| [f.idx, (name_to_digit(f.digit) << name_to_digit(l.digit)).to_i] }
    stdio <~ numbers.group([], sum(:value)).inspected
  end
end

app = App.new(2, :stdin => $stdin)
app.lines <+ ARGF.each_with_index.map{|l, i| [i, l.chomp]}
app.tick
