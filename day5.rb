def scan_ints(line)
  line.scan(/\d+/).map(&:to_i)
end

def pre_process(path)
  parse_moves = false

  crates = []
  moves = []

  File.readlines(path).each do |line|
    if line == "\n"
      parse_moves = true 
      next
    end

    if parse_moves
      moves << scan_ints(line)
    else
      crates << line.chomp
    end
  end

  return [moves, crates]
end

class CargoCrates
  attr_accessor :crates
  
  def initialize(data)
    @crates = {}
    
    data.reverse.each_with_index do |line, i|
      # initialize crates columns
      if i == 0
        scan_ints(line).each { |c| @crates[c] = [] }
        next
      end

      line.scan(/.{1,4}/).each_with_index do |e, i| 
        l = e.scan(/\w/)
        @crates[i + 1] << l[0] if l.size > 0
      end
    end
  end
end

class CrateMover9000
  attr_accessor :crates

  def initialize(moves, crates_data)
    @moves = moves
    @crates = CargoCrates.new(crates_data).crates
  end

  def make_move(count, from, to)
    count.times do
      @crates[to] << @crates[from].pop
    end
  end

  def run
    @moves.each { |m| make_move(*m) }
    @crates.reduce('') { |acc, (_, val)| acc + val.last}
  end
end

class CrateMover9001 < CrateMover9000
  def make_move(count, from, to)
    @crates[to] += @crates[from].pop(count)
  end
end


if $PROGRAM_NAME == __FILE__
  TEST_INPUT = "./content/day5_test_content.txt"
  test_moves_input, test_crates_input = pre_process(TEST_INPUT)

  puts "Moves test pass: #{test_moves_input.size == 4 and test_moves_input.first.size == 3}"

  test_crates_p1 = CargoCrates.new(test_crates_input)
  puts "Crates test pass: #{test_crates_p1.crates.to_s == '{1=>["Z", "N"], 2=>["M", "C", "D"], 3=>["P"]}'}"

  test_crane_p1 = CrateMover9000.new(test_moves_input, test_crates_input)
  test_crane_p1.make_move(*test_moves_input.first)
  puts "Move test pass: #{test_crane_p1.crates.to_s == '{1=>["Z", "N", "D"], 2=>["M", "C"], 3=>["P"]}'}"

  # Reset test
  test_crane_p1 = CrateMover9000.new(test_moves_input, test_crates_input)
  puts "Run test pass: #{test_crane_p1.run == 'CMZ'}"

  # CrateMover9001 tests
  test_crane_p2 = CrateMover9001.new(test_moves_input, test_crates_input)
  puts "P2 Run test pass: #{test_crane_p2.run == 'MCD'}"

  INPUT = "./content/day5_content.txt"
  moves_input, crates_input = pre_process(INPUT)

  crane_p1 = CrateMover9000.new(moves_input, crates_input)
  puts "Part 1 output: #{crane_p1.run}"

  crane_p2 = CrateMover9001.new(moves_input, crates_input)
  puts "Part 2 output: #{crane_p2.run}"
end