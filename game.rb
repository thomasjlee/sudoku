require 'colorize'
require_relative './src/tile'
require_relative './src/presenter'
require_relative './src/board'

class Game
  attr_accessor :board, :presenter

  def initialize(file: nil, presenter: Presenter.new, guesses: [])
    if file.nil?
      presenter.start_prompt
    else
      @board = Board.new(file, presenter)
      @presenter = presenter

      if guesses.empty?
        play_game
      else
        try_guesses(guesses)
        play_game
      end
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

if $0 == __FILE__ then
  Game.new
end

## Run with sudoku1-almost.txt
# ruby -w -I. -rgame -e "Game.new file: './puzzles/sudoku1-almost.txt'"

## Run with sudoku1-almost.txt and winning guess
# ruby -w -I. -rgame -e "Game.new file: './puzzles/sudoku1-almost.txt', guesses: [[0, 8, 4]]"
