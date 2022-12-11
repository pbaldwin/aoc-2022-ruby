Tree = Struct.new(:height, :visible, :scenic_score)

class TreeMap 
  def initialize(input)
    @rows = input.map { |l| l.chomp.chars.map(&:to_i) }
    @cols = @rows.transpose
  end

  def trees
    @trees ||= @rows.map.with_index do |row, i|
      row.map.with_index do |el, j|
        col = @cols[j]
        
        left = row[0, j]
        right = row[j+1..-1]
        top = col[0, i]
        bottom = col[i+1..-1]
        
        visible = true
        
        scenic_score = [left.reverse, right, top.reverse, bottom].reduce(1) do |acc, sl|
          score = 0
          
          for n in sl
            score += 1
            break if n >= el
          end

          acc * score 
        end

        # first and last are always visible
        if row == @rows.first or 
            row == @rows.last or
            j == 0 or
            j == row.size - 1
          Tree.new(el, true, scenic_score)
        else
          if left.max >= el and 
              right.max >= el and 
              top.max >= el and 
              bottom.max >= el
            visible = false
          end

          Tree.new(el, visible, scenic_score)
        end
      end
    end
  end
  
  def total_visible
    trees.flatten.select { |t| t.visible }.size
  end

  def most_scenic
    trees.flatten.map { |t| t.scenic_score }.max
  end
end


if $PROGRAM_NAME == __FILE__
  TEST_INPUT = File.readlines("./content/day8_test_content.txt")

  test_trees = TreeMap.new(TEST_INPUT)
  puts "Visible trees test == 21: #{test_trees.total_visible == 21}"
  puts "Most scenic tree score == 8: #{test_trees.most_scenic == 8}"
  puts test_trees.most_scenic

  INPUT = File.readlines("./content/day8_content.txt")
  trees = TreeMap.new(INPUT)
  puts trees.total_visible
  puts trees.most_scenic
end