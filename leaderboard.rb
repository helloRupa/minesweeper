# Time games, save leaderboard to text, print leaderboard
require 'yaml'

class Leaderboard
  LEVELS = ['easy', 'medium', 'hard']

  def self.start_timer
    @@time = Time.now
  end

  def self.stop_time
    (Time.now - @@time).round(3)
  end

  def self.update_board(level, time)
    self.make_blank_leaderboard unless self.leaderboard_exists?
  end

  def self.leaderboard_exists?
    File.file?('leaderboard.yml')
  end

  def self.make_blank_leaderboard
    leaders = {}
    LEVELS.each { |level| leaders[level] = [] }
    File.open('leaderboard.yml', 'w') { |file| file.write(leaders.to_yaml) }
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
  Leaderboard.update_board('easy', 10)
end
