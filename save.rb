# Save and load games
class Save
  def self.load_game
    filename = self.get_filename
    filename = self.get_filename until File.file?(filename)
    YAML.load(File.read(filename))
  end

  def self.saved_game?
    input = self.yn_answer do 
      puts 'Would you like to load a saved game? (Y/N)'
      print '> '
    end
    input == 'y'
  end

  def self.yn_answer(&msg)
    msg.call
    input = gets.chomp.downcase
    until 'yn'.include?(input) && !input.empty?
      msg.call
      input = gets.chomp.downcase
    end
    input
  end

  def self.filename_msg
    puts
    puts 'Please enter a filename:'
    print '> '
  end

  def self.get_filename
    self.filename_msg
    filename = gets.chomp
    while filename.empty?
      self.filename_msg
      filename = gets.chomp
    end
    filename
  end

  def self.save_game(game)
    input = self.yn_answer do
      puts
      puts 'Would you like to save your game? (Y/N)'
      print '> '
    end
    if input == 'y'
      filename = self.get_filename
      File.open("#{filename}.yml", 'w') { |file| file.write(game.to_yaml) }
      puts 'File saved.'
    end
  end
end
