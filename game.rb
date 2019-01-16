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
    @game_over = false
    mode = get_mode
    @mines = num_mines(mode)
    board_size = board_size(mode)
    @board = Board.new(@mines, board_size)
    @player = Player.new(board_size)
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

  def set_game_over(coords)
    tile = @board.get_tile(coords)
    @game_over = @board.mine?(tile)
    tile.reveal if @game_over
  end

  def game_won?
    @board.complete?
  end

  def turn_msg
    puts 'Please enter an action(f or r) and coordinates, e.g. f0,0 or r1,1'
    print '> '
  end

  def turn(is_first)
    render
    turn_msg
    action, coords = @player.get_input
    @board.populate(coords) if is_first
    if action == 'r'
      @board.reveal(coords)
      set_game_over(coords) unless flagged?(coords)
    else
      @board.flag(coords)
    end
  end

  def flagged?(coords)
    @board.flagged?(coords)
  end

  def game_over_msg
    puts 'Sorry you lose. Better luck next time.'
  end

  def win_msg
    puts 'Congratulations! You win!'
  end

  def run
    turn(true)
    turn(false) until @game_over || game_won?
    render
    @game_over ? game_over_msg : win_msg
  end
end

if $PROGRAM_NAME == __FILE__
  game = Game.new
  game.run
  # game.render
  # game.game_over?([0,0])
end
