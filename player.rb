# Get player input and validate, e.g. f0,0 r0,1
# Player can flag (f) or reveal(r), coords must be on board
class Player
  ACTIONS = 'fr'.freeze

  def initialize(board_size)
    rows, cols = board_size
    @rows_range = (0...rows).to_a
    @cols_range = (0...cols).to_a
  end

  def get_input
    input = format_input(gets.chomp)
    until valid_input?(input) || input == 'quit'
      puts "Please provide a valid action (#{ACTIONS}) and coordinates, e.g. r0,0 or f1,4"
      print '> '
      input = format_input(gets.chomp)
    end
    input == 'quit' ? 'quit' : input_to_array(input)
  end

  private

  def format_input(string)
    string.downcase.delete(' ')
  end

  def parse_input(string)
    action = /[a-z]*/.match(string)
    rest = /\d+.*/.match(string)
    [action, rest]
  end

  def parse_coords(match_data)
    match_data[0].split(',').map(&:to_i)
  end

  def input_to_array(string)
    action, rest = parse_input(string)
    coords = parse_coords(rest)
    [action[0], coords]
  end

  def valid_input?(string)
    action, rest = parse_input(string)
    return false if [action, rest].any?(&:nil?) || action[0].empty?
    x, y = parse_coords(rest)
    return true if @rows_range.include?(x) && @cols_range.include?(y) && 
                   ACTIONS.include?(action[0])
    false
  end
end

if $PROGRAM_NAME == __FILE__
  player = Player.new([9, 9])
  p player.get_input
end
