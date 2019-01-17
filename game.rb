# Play Minesweeper in the Terminal / CLI
require 'yaml'
require_relative './player.rb'
require_relative './board.rb'
require_relative './save.rb'

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

  WELCOME_WAIT = 3

  private_class_method :new

  def self.minesweeper
    self.welcome_message
    game = Save.saved_game? ? Save.load_game : new
    should_save = game.run
    exit(true) unless should_save
    Save.save_game(game)
    self.goodbye_msg
  end

  def self.goodbye_msg
    puts
    puts 'Goodbye.'
  end

  def initialize
    @is_first = true
    @game_over = false
    mode = get_mode
    @mines = num_mines(mode)
    board_size = board_size(mode)
    @board = Board.new(@mines, board_size)
    @player = Player.new(board_size)
  end

  def self.clear_screen(secs = 0)
    sleep(secs)
    system('clear')
  end

  def self.welcome_message
    self.clear_screen
    puts 'Welcome to Minesweeper!'
    puts
    puts "The goal is to reveal all spaces that aren't mines. If you select a mine, it's game over!"
    puts
    puts 'To play, choose an action: reveal (r) or flag (f) followed by the coordinates for a space (e.g. r0,0).'
    puts "Reveal shows the space's value, while flag places a flag on it, meaning you think there's a mine."
    puts "You can't reveal a space that's flagged. You must unflag it first using the flag action."
    puts
    puts 'Good luck! Bonne chance!'
    puts
    self.clear_screen(WELCOME_WAIT)
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
    puts
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
    Game.clear_screen
    puts "Mines: #{@mines - @board.flag_count}"
    puts
    @board.render
    puts
  end

  def set_game_over(coords)
    tile = @board.get_tile(coords)
    @game_over = @board.mine?(tile)
  end

  def game_won?
    @board.complete?
  end

  def turn_msg
    puts 'Please enter an action(f or r) and coordinates, e.g. f0,0 or r1,1'
    print '> '
  end

  def make_move(input)
    action, coords = input
    @board.populate(coords) if @is_first
    if action == 'r'
      @board.reveal(coords)
      set_game_over(coords) unless flagged?(coords)
    else
      @board.flag(coords)
    end
  end

  def turn
    render
    turn_msg
    input = @player.get_input
    return true if input == 'quit'
    make_move(input)
    false
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
    exit_code = turn
    @is_first = false
    exit_code = turn until @game_over || game_won? || exit_code
    return true if exit_code
    render
    @game_over ? game_over_msg : win_msg
    false
  end
end

if $PROGRAM_NAME == __FILE__
  Game.minesweeper
end
