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
    welcome_message
    mode = get_mode
    @mines = num_mines(mode)
    @board = Board.new(@mines, board_size(mode))
  end

  def welcome_message
    puts 'Welcome to Minesweeper!'
    puts
    puts "The goal is to reveal all spaces that aren't mines. If you select a mine, it's game over!"
    puts
    puts "To play, choose an action: reveal (r) or flag (f) followed by the coordinates for a space (e.g. r0,0)." 
    puts "Reveal shows the space's value, while flag places a flag on it, meaning you think there's a mine."
    puts "You can't reveal a space that's flagged. You must unflag it first using the flag action."
    puts
    puts "Good luck! Bonne chance!"
    puts
  end

  def get_mode
    mode_msg
    mode = gets.chomp.downcase
    until MODES.key?(mode)
      mode_msg
      mode = gets.chomp.downcase
    end
    mode
  end

  def mode_msg
    puts 'Please choose a difficulty: easy, medium or hard:'
    print '> '
  end

  def num_mines(mode)
    MODES[mode][:mines]
  end

  def board_size(mode)
    MODES[mode][:size]
  end

  def render
    puts "Mines: #{@mines - @board.flag_count}"
    puts
    @board.render
    puts
  end
end

if $PROGRAM_NAME == __FILE__
  game = Game.new
  game.render
end
