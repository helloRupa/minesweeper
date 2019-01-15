# Populate board w/ numerical, bomb, etc tiles and render
class Board
  MODES = {
    easy: {
      mines: 10,
      size: [9, 9]
    },
    medium: {
      mines: 40,
      size: [16, 16]
    },
    hard: {
      mines: 99,
      size: [16, 30]
    }
  }.freeze

  def initialize(mode)
    @mines = num_mines(mode)
    @rows, @cols = board_size(mode)
    @board = empty_board
  end

  def num_mines(mode)
    MODES[mode][:mines]
  end

  def board_size(mode)
    MODES[mode][:size]
  end

  def empty_board
    arr = []
    @rows.times { arr << Array.new(@cols) }
    arr
  end

  def print_row_header
    puts "  #{(0...@rows).to_a.join(' ')}"
  end

  def row_to_string(row)
    row.map do |tile|
      tile.nil? || !tile.revealed ? '*' : tile.value
    end
  end

  def print_rows
    @board.each_with_index do |row, idx|
      print "#{idx} "
      puts row_to_string(row).join(' ')
    end
  end

  def render
    print_row_header
    print_rows
  end
end

if $PROGRAM_NAME == __FILE__
  board = Board.new(:easy)
  board.render
end
