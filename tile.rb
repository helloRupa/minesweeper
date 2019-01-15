# Each tile holds a value, tracks whether it was flagged or revealed
class Tile
  attr_reader :revealed, :value, :flagged

  def initialize(value)
    @value = value
    @revealed = false
    @flagged = false
  end

  def reveal
    @revealed = true unless @flagged
    @revealed
  end

  def flag
    @flagged = !@flagged unless @revealed
    @flagged
  end
end

if $PROGRAM_NAME == __FILE__
  tile = Tile.new('cat')
  p tile.flag # flagged true
  p tile.reveal # revealed false
  p tile.flag # flagged false
  p tile.reveal # revealed true
end
