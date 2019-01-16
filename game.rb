# Play Minesweeper in the Terminal / CLI
require_relative './player.rb'
require_relative './board.rb'

class Game
  MODES = {
    'easy' => {
      mines: 10,
      size: [9, 9]
    },
    'medium' => {
      mines: 40,
      size: [16, 16]
    },
    'hard' => {
      mines: 99,
      size: [16, 30]
    }
  }.freeze

  def initialize
    mode = get_mode
    @board = Board.new(num_mines(mode), board_size(mode))
    p @board.board
  end

  def get_mode
    puts 'Please choose a difficulty: easy, medium or hard:'
    mode = gets.chomp.downcase
    until MODES.key?(mode)
      puts 'Please choose a difficulty: easy, medium or hard:'
      mode = gets.chomp.downcase
    end
    mode
  end

  def num_mines(mode)
    MODES[mode][:mines]
  end

  def board_size(mode)
    MODES[mode][:size]
  end
end

if $PROGRAM_NAME == __FILE__
  game = Game.new
end
