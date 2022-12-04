class TaskRanges
  def initialize(data)
    @data = data.map do |line| 
      line.split(",").map do |r| 
        a,b = r.split("-").map(&:to_i)
        (a..b)
      end
    end
  end

  def compare_ranges(r1, r2)
    (r1.cover? r2) or (r2.cover? r1)
  end

  def overlaps
    @data.reduce(0) { |sum, line| compare_ranges(*line) ? sum += 1 : sum}
  end
end

class TaskRangesIntersect < TaskRanges
  def compare_ranges(r1, r2)
    r1.to_a.intersect?(r2.to_a)
  end
end

if $PROGRAM_NAME == __FILE__
  test_input = File.readlines("./content/day4_test_content.txt")
  test_p1 = TaskRanges.new(test_input)

  puts "Should be true: #{test_p1.compare_ranges(2..3, 1..4)}"
  puts "Should be true: #{test_p1.compare_ranges(6..6, 2..7)}"
  puts "Should be false: #{test_p1.compare_ranges(2..3, 4..6)}"
  puts "Should be 2: #{test_p1.overlaps}"
  
  test_p2 = TaskRangesIntersect.new(test_input)

  puts "Should be true: #{test_p2.compare_ranges(5..7, 7..9)}"
  puts "Should be true: #{test_p2.compare_ranges(2..8, 3..7)}"
  puts "Should be false: #{test_p2.compare_ranges(1..3, 4..9)}"
  puts "Should be 4: #{test_p2.overlaps}"

  input = File.readlines("./content/day4_content.txt")
  p1 = TaskRanges.new(input)
  puts p1.overlaps

  p2 = TaskRangesIntersect.new(input)
  puts p2.overlaps
end