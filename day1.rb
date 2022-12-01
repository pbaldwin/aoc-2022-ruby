class CaloryCounter
  def initialize(file)
    @sums = self.organize_calories(file)
  end
  
  def organize_calories(file)
    sums = [0]

    File.foreach(file) do |i|
      i.to_i == 0 ? sums << 0 : sums[-1] += i.to_i 
    end
    
    return sums
  end
  
  def most_calories
    @sums.max
  end

  def top_three_sum
    @sums.sort.reverse.slice(0,3).reduce(:+)
  end
end

if $PROGRAM_NAME == __FILE__
  test_counter = CaloryCounter.new("./content/day1_test_content.txt")

  puts "Most Calories Tests Pass:"
  puts "Most: #{test_counter.most_calories == 24000}"
  puts "Top three: #{test_counter.top_three_sum == 45000}"

  cal_counter = CaloryCounter.new("./content/day1_content.txt")
  puts cal_counter.most_calories
  puts cal_counter.top_three_sum
end