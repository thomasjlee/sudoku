require 'byebug'

class Presenter
  def start_prompt
    puts "=== SUDOKU ==="
    puts "sudoku1-almost.txt"
    puts "sudoku1-solved.txt"
    puts "sudoku1.txt"
    puts "sudoku2.txt"
    puts "sudoku3.txt"
    puts "sudoku4.txt"
    puts ""
    print "Choose a puzzle. Type in the complete file name: "
    file = gets.chomp
    puts "!!!!!!!!! ./puzzles/#{file}"
    Game.new(file: "./puzzles/#{file}", presenter: Presenter.new)
  end

  def render(grid)
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

      render_left  = render_row[0..2].join(" ")
      render_mid   = render_row[3..5].join(" ")
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

  def immutable_tile_msg
    puts "That tile was given. Pick a new tile."
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
