# Time games, save leaderboard to text, print leaderboard
class Leaderboard
  def self.start_timer
    @@time = Time.now
  end

  def self.stop_time
    (Time.now - @@time).round(3)
  end
end

if $PROGRAM_NAME == __FILE__
  Leaderboard.start_timer
  
  input = nil
  until input == 'y'
    print '> '
    input = gets.chomp
  end
  p Leaderboard.stop_time
end
