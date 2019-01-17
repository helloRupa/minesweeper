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
    leaders = YAML.load(File.read('leaderboard.yml'))
    unless self.level_exists?(leaders, level)
      puts "Sorry, can't update leaderboard. Level doesn't exist."
      return
    end

    self.update_leader_hash(leaders[level], time)
    self.save_leaderboard(leaders)
  end

  def self.update_leader_hash(leaders, time)
    if leaders.empty? || leaders.length < 10 || time < leaders[-1][1]
      leaders.pop if leaders.length == 10
      leaders.push([self.player_name, time])
      leaders.sort_by! { |leader| leader[1] }
    end
  end

  def self.player_name
    name = ''
    while name.empty?
      puts 'Please enter your name for the leaderboard:'
      print '> '
      name = gets.chomp
    end
    name
  end

  def self.level_exists?(leaders, level)
    leaders.key?(level)
  end

  def self.leaderboard_exists?
    File.file?('leaderboard.yml')
  end

  def self.save_leaderboard(leaders)
    File.open('leaderboard.yml', 'w') { |file| file.write(leaders.to_yaml) }
  end

  def self.make_blank_leaderboard
    leaders = {}
    LEVELS.each { |level| leaders[level] = [] }
    self.save_leaderboard(leaders)
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
  Leaderboard.update_board('easy', 5)
  Leaderboard.update_board('easy', 15)
  Leaderboard.update_board('easy', 1)
end
