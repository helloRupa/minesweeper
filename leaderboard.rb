# Time games, save leaderboard to text, print leaderboard
require 'yaml'
require 'colorize'

class Leaderboard
  @@levels = ['easy', 'medium', 'hard']
  JUSTIFY = 35
  MAX_NAME_LENGTH = 20

  def self.start_timer
    @@time = Time.now
  end

  def self.set_levels(levels_arr)
    @@levels = levels_arr
  end

  def self.update_and_print(level)
    time = self.stop_time
    self.completion_time_msg(time)
    self.update_board(level, time)
    self.print_leaders
  end

  def self.stop_time
    (Time.now - @@time).round(3)
  end

  def self.completion_time_msg(time)
    puts
    puts "You completed the game in #{time} seconds."
    puts 'See how you did on the leaderboard.'
    puts
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
    @@levels.each { |level| leaders[level] = [] }
    self.save_leaderboard(leaders)
  end

  def self.print_leaders
    leaders = YAML.load(File.read('leaderboard.yml'))
    puts
    puts 'Leaderboard:'.colorize(:yellow)
    leaders.each do |level, l_arr|
      puts level.upcase.colorize(:green)
      self.print_names_and_times(l_arr)
      puts
    end
  end

  def self.print_names_and_times(l_arr)
    puts 'No leaders yet.' if l_arr.empty?
    l_arr.each_with_index do |score_arr, idx|
      name, time = score_arr
      name = self.truncate_name(name)
      justify = JUSTIFY - name.length
      justify -= 1 if idx > 8
      puts "#{idx + 1}. #{name} #{time.to_s.rjust(justify)} secs."
    end
  end

  def self.truncate_name(name)
    return name if name.length <= MAX_NAME_LENGTH
    "#{name[0..MAX_NAME_LENGTH]}..."
  end
end

if $PROGRAM_NAME == __FILE__
  # Leaderboard.update_board('easy', 250)
  # Leaderboard.update_board('easy', 249)
  # Leaderboard.update_board('medium', 500)
  # Leaderboard.update_board('medium', 480)
  # Leaderboard.update_board('medium', 530)
  # Leaderboard.update_board('hard', 1000)
  # Leaderboard.update_board('hard', 1200)
  # Leaderboard.update_board('hard', 999)
  Leaderboard.print_leaders
  # Leaderboard.start_timer
  # sleep(5)
  # Leaderboard.update_and_print('easy')
  # Leaderboard.print_leaders
  # Leaderboard.start_timer

  # input = nil
  # until input == 'y'
  #   print '> '
  #   input = gets.chomp
  # end
  # p Leaderboard.stop_time
  # Leaderboard.update_board('easy', 10)
  # Leaderboard.update_board('easy', 5)
  # Leaderboard.update_board('easy', 15)
  # Leaderboard.update_board('easy', 1)
end
