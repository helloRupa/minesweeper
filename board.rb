# Populate board w/ numerical, bomb, etc tiles and render
# On init, creates empty board, after first click game should populate
require './tile.rb'
require 'colorize'

class Board
  SPACES = {
    empty: '_',
    unclicked: '*',
    mine: 'M',
    flag: 'F'
  }.freeze

  SEARCH_AREA = [[-1, -1], [-1,0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].freeze

  COLORS = { '1' => :blue, '2' => :light_blue, '3' => :green, '4' => :light_green, '5' => :magenta, 
             '6' => :light_magenta, '7' => :cyan, '8' => :light_black, 'F' => :yellow, 'M' => :red }.freeze

  attr_reader :board

  def initialize(mines, size_arr)
    @mines = mines
    @rows, @cols = size_arr
    @board = empty_board
  end

  def populate(exclude_coords)
    make_mines(exclude_coords)
    make_spaces
  end

  def reveal(coords)
    cascade(coords)
  end

  def flag(coords)
    y, x = coords
    @board[y][x].flag
  end

  def flagged?(coords)
    tile = get_tile(coords)
    tile.flagged
  end

  def complete?
    @board.each do |row|
      row.each do |tile|
        next if mine?(tile)
        return false unless tile.revealed
      end
    end
    true
  end

  def render
    print_row_header
    print_rows
  end

  def get_tile(coords)
    y, x = coords
    @board[y][x]
  end

  def mine?(tile)
    tile.value == SPACES[:mine]
  end

  def flag_count
    count = 0
    @board.each do |row|
      row.each do |tile|
        next if tile.nil?
        count += 1 if tile.flagged
      end
    end
    count
  end

  private

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
      if tile.nil?
        SPACES[:unclicked]
      elsif tile.flagged
        SPACES[:flag]
      else
        tile.revealed ? tile.value : SPACES[:unclicked]
      end
    end.join(' ')
  end

  def print_rows
    @board.each_with_index do |row, idx|
      print "#{idx} "
      print_color_row(row_to_string(row))
    end
  end

  def print_color_row(string)
    string.chars do |char|
      print COLORS.key?(char) ? char.colorize(COLORS[char]) : char
    end
    puts
  end

  def make_mines(exclude_coords)
    mine_number = @mines
    while mine_number > 0
      x = rand(@cols)
      y = rand(@rows)
      next if exclude_coords == [y, x] || !@board[y][x].nil?
      make_tile([y, x], 'mine')
      mine_number -= 1
    end
  end

  def on_board?(coords)
    y, x = coords
    (0...@rows).cover?(y) && (0...@cols).cover?(x)
  end

  def count_mines(coords)
    y, x = coords
    mine_count = 0
    SEARCH_AREA.each do |s_y, s_x|
      next unless on_board?([y + s_y, x + s_x])
      tile = get_tile([y + s_y, x + s_x])
      next if tile.nil?
      mine_count += 1 if mine?(tile)
    end
    mine_count
  end

  def make_tile(coords, val)
    y, x = coords
    @board[y][x] = case val
                   when 'mine' then Tile.new(SPACES[:mine])
                   when 0 then Tile.new(SPACES[:empty])
                   else Tile.new(val.to_s)
                   end
  end

  def make_spaces
    @board.each_with_index do |row, y|
      row.each_with_index do |tile, x|
        next unless tile.nil?
        coords = [y, x]
        mine_count = count_mines(coords)
        make_tile(coords, mine_count)
      end
    end
  end

  def empty_tile?(tile)
    tile.value == SPACES[:empty]
  end

  def cascade(coords, searched = [])
    return if searched.include?(coords) || !on_board?(coords)

    searched << coords
    tile = get_tile(coords)
    tile.reveal
    reveal_more(coords, searched) if empty_tile?(tile)
  end

  def reveal_more(coords, searched)
    y, x = coords
    SEARCH_AREA.each { |s_y, s_x| cascade([y + s_y, x + s_x], searched) }
  end
end

if $PROGRAM_NAME == __FILE__
  board = Board.new(10, [9,9])
  board.render
  board.populate([3, 3])
  board.reveal([3, 3])
  board.render
end
