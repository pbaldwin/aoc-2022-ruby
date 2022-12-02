# Rock: A / X
# Paper: B / Y
# Scissors: C / Z
class RPS
  WINS = [
    %w{ A Y },
    %w{ B Z },
    %w{ C X }
  ]

  PLAY_SCORES = { 
    "X" => 1, "Y" =>  2, "Z" => 3,
    "A" => 1, "B" => 2, "C" => 3,
  }
  OUTCOME_SCORES = { lose: 0, draw: 3, win: 6}

  def initialize(move_set)
    @move_set = move_set.map { |moves| moves.chomp.split(" ") }
  end

  def get_coutcome(move)
    outcome = 0
    m1 = PLAY_SCORES[move[0]]
    m2 = PLAY_SCORES[move[1]]
    
    if m1 == m2
      # Draw
      outcome = OUTCOME_SCORES[:draw]
    elsif WINS.include?(move)
      # We win
      outcome = OUTCOME_SCORES[:win]
    end

    outcome + m2
  end

  def final_score
    @move_set.reduce(0) do |tally, move|
      score = get_coutcome(move)

      tally += score
    end
  end
end

class RPS2 < RPS
  OUTCOME_CONDITION = {
    "X" => :lose, "Y" => :draw, "Z" => :win
  }

  def find_move(opponent_move, condition)
    case condition
    when :draw
      return opponent_move
    when :lose
      return opponent_move == 1 ? 3 : opponent_move - 1
    when :win
      return opponent_move == 3 ? 1 : opponent_move + 1
    end
  end

  def get_coutcome(move)
    m1 = PLAY_SCORES[move[0]]
    outcome = OUTCOME_CONDITION[move[1]]
    m2 = find_move(m1, outcome)
    
    OUTCOME_SCORES[outcome] + m2
  end
end

# Run program here
if $PROGRAM_NAME == __FILE__
  test_input = File.readlines("./content/day2_test_content.txt")
  test_rps = RPS.new(test_input)
  test_rps2 = RPS2.new(test_input)

  puts "Rock Paper Scissors Tests Pass:"
  puts test_rps.final_score == 15
  puts test_rps2.final_score == 12

  input = File.readlines("./content/day2_content.txt")
  rps = RPS.new(input)
  rps2 = RPS2.new(input)

  puts rps.final_score
  puts rps2.final_score
end