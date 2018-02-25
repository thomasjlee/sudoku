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
          tile_row << Tile.new(tile, presenter)
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
