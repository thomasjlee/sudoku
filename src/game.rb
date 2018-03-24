require 'colorize'
require_relative 'tile'
require_relative 'presenter'
require_relative 'board'

class Game
  attr_accessor :board, :presenter

  def initialize(file: nil, presenter: Presenter.new)
    return presenter.start_prompt if file.nil?
    @board = Board.new(file, presenter)
    @presenter = presenter
    play_game
  end

  private
    def play_game
      until board.all_solved?
        presenter.render(board.grid)
        x     = presenter.prompt_x
        y     = presenter.prompt_y
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
