# Play Minesweeper in the Terminal / CLI
require 'yaml'
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

  private_class_method :new

  def self.minesweeper
    game = new
    exit_code = game.run
    exit(true) unless exit_code
    game.save_game
    puts 'Goodbye.'
  end

  def self.load_game(filename)
    game = YAML.load(File.read(filename))
    game.run
  end

  def initialize
    welcome_message
    @is_first = true
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
    puts 'To play, choose an action: reveal (r) or flag (f) followed by the coordinates for a space (e.g. r0,0).'
    puts "Reveal shows the space's value, while flag places a flag on it, meaning you think there's a mine."
    puts "You can't reveal a space that's flagged. You must unflag it first using the flag action."
    puts
    puts 'Good luck! Bonne chance!'
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
  end

  def game_won?
    @board.complete?
  end

  def turn_msg
    puts 'Please enter an action(f or r) and coordinates, e.g. f0,0 or r1,1'
    print '> '
  end

  def turn
    render
    turn_msg
    input = @player.get_input

    if input == 'quit'
      return true
    else
      puts @is_first
      action, coords = input
      @board.populate(coords) if @is_first
      if action == 'r'
        @board.reveal(coords)
        set_game_over(coords) unless flagged?(coords)
      else
        @board.flag(coords)
      end
    end
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

  def save_msg
    puts 'Would you like to save your game? (Y/N)'
    print '> '
  end

  def get_save_answer
    save_msg
    input = gets.chomp.downcase
    until 'yn'.include?(input) && !input.empty?
      save_msg
      input = gets.chomp.downcase
    end
    input
  end

  def filename_msg
    puts 'Please enter a filename:'
    print '> '
  end

  def get_filename
    filename_msg
    filename = gets.chomp
    while filename.empty?
      filename_msg
      filename = gets.chomp
    end
    filename
  end

  def save_game
    input = get_save_answer
    if input == 'y'
      filename = get_filename
      File.open("#{filename}.yml", "w") { |file| file.write(self.to_yaml) }
      puts 'File saved.'
    end
  end
end

if $PROGRAM_NAME == __FILE__
  Game.minesweeper
  # Game.load_game('testing.yml')
end
