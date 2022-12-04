class RucksackParser
  def initialize(data)
    @data = data.map { |s| s.chomp.split("").each_slice(s.size / 2).to_a }
  end

  def find_duplicate(set_a, set_b)
    (set_a & set_b).first
  end

  def get_priority(ch)
    o = ch.ord

    if /[[:upper:]]/.match(ch)
      return o - 38
    else
      return o - 96
    end
  end

  def total_priority
    @data.reduce(0) do |priority, lists|
      ch = find_duplicate(*lists)
      priority += get_priority(ch)
    end
  end
end

class TrioRucksackParser < RucksackParser
  def initialize(data)
    @data = data.map { |s| s.chomp.split("").uniq }.each_slice(3).to_a
  end

  def find_duplicate(set_a, set_b, set_c)
    (set_a & set_b & set_c).first
  end
end

if $PROGRAM_NAME == __FILE__
  test_input = File.readlines("./content/day3_test_content.txt")
  test_ruck = RucksackParser.new(test_input)
  test_trios = TrioRucksackParser.new(test_input)

  puts "Rucksack Pass Test:"
  puts test_ruck.total_priority == 157
  puts test_trios.total_priority == 70

  input = File.readlines("./content/day3_content.txt")
  ruck = RucksackParser.new(input)
  trios = TrioRucksackParser.new(input)

  puts ruck.total_priority
  puts trios.total_priority
end