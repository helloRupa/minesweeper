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
    @size = board_size(mode)
    p @mines
    p @size
  end

  def num_mines(mode)
    MODES[mode][:mines]
  end

  def board_size(mode)
    MODES[mode][:size]
  end
end

if $PROGRAM_NAME == __FILE__
  board = Board.new(:easy)
end
