def start_of_unique(input, length)
  indicator = ""
  
  (0..input.size).each do |i|
    tmp = input[i, length]
    if (tmp.chars.to_a.uniq.size == length)
      indicator = tmp
      break
    end
  end

  return input.index(indicator) + length
end

if $PROGRAM_NAME == __FILE__
  TEST_INPUT = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"

  puts "Test pt 1 pass: #{start_of_unique(TEST_INPUT, 4) == 7}"
  puts "Test pt 2 pass: #{start_of_unique(TEST_INPUT, 14) == 19}"
  
  PATH = "./content/day6_content.txt"
  INPUT = File.read(PATH)

  # Part 1
  puts start_of_unique(INPUT, 4)

  # Part 1
  puts start_of_unique(INPUT, 14)
end