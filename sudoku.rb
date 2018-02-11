require 'pry'
require 'byebug'
require 'colorize'

class Tile
  attr_accessor :tile
  attr_reader :mutable

  def initialize(tile)
    @mutable = tile == "0"
    @tile = tile == "0" ? "-" : tile
  end

  def tile=(new_tile)
    if mutable
      @tile = new_tile
    else
      puts "That tile was given. Pick a new tile."
    end
  end
end

class Board
  attr_reader :presenter
  attr_accessor :grid

  def initialize(file, presenter)
    @presenter = presenter
    @grid = []

    set_grid(file)
  end

  def set_grid(file)
    File.open(file) do |f|
      f.each_line do |line|
        tile_row = []
        line.chomp.chars.each do |tile|
          tile_row << Tile.new(tile)
        end

        grid << tile_row
      end
    end
  end

  def update(x, y, new_value)
    y = (y - 8).abs
    grid[y][x].tile = new_value.to_s

    if full_board?
      if !all_solved?
        presenter.unsolved_full_msg
      end
    end
  end

  def full_board?
    !grid.flatten.map { |tile_obj| tile_obj.tile }.include?("-")
  end

  def all_solved?
    solved_rows? && solved_columns? && solved_squares?
  end

  def solved_rows?
    solved = false
    grid.each do |row|
      tile_row = row.map { |tile_obj| tile_obj.tile.to_i }
      solved = (!tile_row.include?(0) && (tile_row == tile_row.uniq)) ? true : false
      return nil if !solved
    end
    solved
  end

  def solved_columns?
    solved = false
    i = 0
    while i < 9
      tile_column = grid.map { |arr| arr[i].tile.to_i }
      solved = !tile_column.include?(0) && (tile_column == tile_column.uniq) ? true : false
      return nil if !solved
      i += 1
    end
    solved
  end

  def solved_squares?
    solved = false
    i = 0
    while i < 9
      j = 0
      while j < 9
        square = []
        @grid[j..j+2].each do |row|
          row[i..i+2].each do |tile|
            square << tile.tile.to_i
          end
        end
        j += 3
        solved = !square.include?(0) && (square == square.uniq) ? true : false
        return nil if !solved
      end
      i += 3
    end
    solved
  end
end

class Game
  attr_accessor :board, :presenter

  def initialize(file: nil, presenter: Presenter.new, guesses: [])
    if file.nil?
      presenter.start_prompt
    end

    @board = Board.new(file, presenter)
    @presenter = presenter

    if guesses.empty?
      play_game
    else
      try_guesses(guesses)
      play_game
    end
  end

  private

  def try_guesses(guesses)
    guesses.each do |x_y_tile|
      x    = x_y_tile[0]
      y    = x_y_tile[1]
      tile = x_y_tile[2]

      if (presenter.is_valid_coord?(x) && presenter.is_valid_coord?(y) && presenter.is_valid_tile?(tile))
        board.update(x, y, tile)
      end
    end
  end

  def play_game
    until board.all_solved?
      presenter.render(board.grid)
      x = presenter.prompt_x
      y = presenter.prompt_y
      value = presenter.prompt_tile_value.to_s
      board.update(x, y, value)
    end

    end_game
  end

  def end_game
    presenter.render(board.grid)
    presenter.win_msg
  end
end

class Presenter
  def start_prompt
    puts "=== SUDOKU ==="
    puts ""
    puts "sudoku1-almost.txt"
    puts "sudoku1-solved.txt"
    puts "sudoku1.txt"
    puts "sudoku2.txt"
    puts "sudoku3.txt"
    puts "sudoku4.txt"
    puts ""
    print "Type in the complete puzzle file name: "
    file = gets.chomp
    Game.new(file: "#{file}", presenter: Presenter.new)
  end

  def render(grid)
    # sleep(0.1)
    puts ""

    div_placer = 0
    v_spacer = " | "
    v_count = 8

    grid.each do |row|
      render_row = row.map do |tile_obj|
        if tile_obj.mutable
          tile_obj.tile.colorize(:white)
        else
          tile_obj.tile.colorize(:red)
        end
      end

      puts "  +-------+-------+-------+" if div_placer == 0

      render_left = render_row[0..2].join(" ")
      render_mid = render_row[3..5].join(" ")
      render_right = render_row[6..8].join(" ")

      puts v_count.to_s.colorize(:blue) + v_spacer + render_left + v_spacer + render_mid + v_spacer + render_right + v_spacer

      div_placer += 1
      v_count -= 1

      puts "  +-------+-------+-------+" if div_placer % 3 == 0
    end
    puts "    0 1 2   3 4 5   6 7 8".colorize(:blue)
    puts ""
    return nil
  end

  def prompt_x
    print "Pick a tile: x-coordinate = "
    validate_coordinate(gets.chomp)
  end

  def prompt_y
    print "Pick a tile: y-coordinate = "
    validate_coordinate(gets.chomp)
  end

  def validate_coordinate(coord)
    unless is_valid_coord?(coord)
      print "Invalid coordinate. Enter a coordinate between 0 and 8: "
      coord = validate_coordinate(gets.chomp)
    end
    coord.to_i
  end

  def is_valid_coord?(coord)
    coord.to_s.length == 1 && coord.to_s.ord >= 48 && coord.to_s.ord <= 56
  end

  def prompt_tile_value
    print "New tile value = "
    validate_tile(gets.chomp.to_i)
  end

  def validate_tile(tile)
    until is_valid_tile?(tile)
      print "Please enter an integer between 1 and 9: "
      tile = validate_tile(gets.chomp.to_i)
    end
    tile
  end

  def is_valid_tile?(tile)
    tile >= 1 && tile <= 9
  end

  def unsolved_full_msg
    puts "Board is full, but you haven't solved the puzzle."
  end

  def win_msg
    puts ""
    puts "       `~`~`~`~`~`~`~`".colorize(:red)
    puts "           YOU WIN!"
    puts "       `~`~`~`~`~`~`~`".colorize(:red)
    puts ""
  end
end

class MockPresenter
  def initialize;
  end

  def render(mock_grid);
    puts "  +-------+-------+-------+"
  end

  def prompt_x;
    0
  end

  def prompt_y;
    8
  end

  def validate_coordinate;
  end

  def prompt_tile_value;
    4
  end

  def validate_tile;
  end

  def win_msg;
    puts "YOU WIN!"
  end
end

if $0 == __FILE__ then
  puts "The game would be loaded"
end

## Allow puzzle selection
# ruby -w -I. -rsudoku -e "Presenter.start_prompt"

## Run with sudoku1-almost.txt
# ruby -w -I. -rsudoku -e "Game.new file: './sudoku1-almost.txt'"

## Run with sudoku1-almost.txt AND winning guess
# ruby -w -I. -rsudoku -e "Game.new file: './sudoku1-almost.txt', guesses: [[0,8,4]]"

## Run with sudoku1-almost.txt and MockPresenter for testing
# ruby -w -I. -rsudoku -e "Game.new file: './sudoku1-almost.txt', presenter: MockPresenter.new"
