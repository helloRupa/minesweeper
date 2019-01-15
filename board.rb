# Populate board w/ numerical, bomb, etc tiles and render
# On init, creates empty board, after first click game should populate
require './tile.rb'

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

  SPACES = {
    empty: '_',
    unclicked: '*',
    mine: 'M',
    flag: 'F'
  }.freeze

  SEARCH_AREA = [[-1, -1], [-1,0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].freeze

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
      puts row_to_string(row)
    end
  end

  def render
    print_row_header
    print_rows
  end

  def get_tile(y, x)
    @board[y][x]
  end

  def make_mines(exclude_coords)
    mine_number = @mines
    while mine_number > 0
      x = rand(@cols)
      y = rand(@rows)
      next if exclude_coords == [y, x] || !@board[y][x].nil?
      make_tile([y, x], 'mine')
      @board[y][x].reveal
      mine_number -= 1
    end
  end

  def on_board?(y, x)
    (0...@rows).cover?(y) && (0...@cols).cover?(x)
  end

  def count_mines(coords)
    y, x = coords
    mine_count = 0
    SEARCH_AREA.each do |s_y, s_x|
      next unless on_board?(y + s_y, x + s_x)
      tile = get_tile(y + s_y, x + s_x)
      next if tile.nil?
      mine_count += 1 if mine?(tile)
    end
    mine_count
  end

  def mine?(tile)
    tile.value == SPACES[:mine]
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
        @board[y][x].reveal
      end
    end
  end

  def populate(exclude_coords)
    make_mines(exclude_coords)
    make_spaces
  end
end

if $PROGRAM_NAME == __FILE__
  board = Board.new(:easy)
  # board.make_mines([1, 1])
  board.populate([1, 1])
  board.render
end
