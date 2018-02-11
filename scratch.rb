require 'pp'

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
  attr_reader :presenter, :grid

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
end

pp Board.new('./sudoku1.txt', 'presenter').grid
