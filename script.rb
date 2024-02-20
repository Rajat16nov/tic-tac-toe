class Board
  def initialize
    @grid = Array.new(3) { Array.new(3, " ") }
  end

  def display
    @grid.each_with_index do |row, index|
      puts row.join(" | ")
      puts "---------" unless index == @grid.size - 1
    end
  end

  def place_marker(row, col, marker)
    if @grid[row][col] == " "
      @grid[row][col] = marker 
      return true
    else
      return false
    end
  end

  def winning_combination?(marker)
    @grid.each do |row|
      return true if row.all? { |cell| cell == marker }
    end

    (0..2).each do |col|
      return true if @grid.all? { |row| row[col] == marker }
    end

    return true if [@grid[0][0], @grid[1][1], @grid[2][2]].all? { |cell| cell == marker }
    return true if [@grid[0][2], @grid[1][1], @grid[2][0]].all? { |cell| cell == marker }

    false
  end

  def is_full?
    @grid.flatten.all? { |cell| cell != " " }
  end
end

class Player
  attr_reader :name, :marker

  def initialize(name, marker)
    @name = name
    @marker = marker
  end
end

class Game
  def initialize
    @board = Board.new
    @player1 = Player.new("Player 1", "X")
    @player2 = Player.new("Player 2", "O")
    @current_player = @player1
  end

  def switch_turns
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  def play
    until game_over?
      @board.display
      puts "#{@current_player.name}'s turn (#{@current_player.marker}):"
      puts "Which row?"
      row = gets.chomp.to_i-1
      puts "Which column?"
      col = gets.chomp.to_i-1
      if @board.place_marker(row, col, @current_player.marker)
        break if @board.winning_combination?(@current_player.marker)
        switch_turns
      end
    end
    @board.display
    if @board.winning_combination?(@current_player.marker)
      puts "#{@current_player.name} Won"
    elsif @board.is_full?
      puts "It's a draw"
    end
  end

  def game_over?
    @board.is_full? || @board.winning_combination?(@current_player.marker)
  end
end

game = Game.new
game.play
