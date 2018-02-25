require_relative '../src/game'
require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

describe Game do
  describe "already solved board" do
    before do
      @solved_game = Proc.new {Game.new(
          file: 'test/fixtures/sudoku_solved.txt',
          presenter: Presenter.new
        )}
    end

    it "renders the board" do
      @solved_game.must_output(/\+-------\+-------\+-------\+/)
    end

    it "displays the win message" do
      @solved_game.must_output(/WIN!/)
    end
  end

  describe "board with one unsolved tile" do
    before do
      @guess = [0, 8, 4]
      @almost_solved_game = Proc.new {Game.new(
          file: 'test/fixtures/sudoku_almost.txt',
          presenter: Presenter.new,
          guesses: [@guess]
        )}
    end

    it "renders the board" do
      @almost_solved_game.must_output(/\+-------\+-------\+-------\+/)
    end

    it "displays the win message" do
      @almost_solved_game.must_output(/WIN!/)
    end
  end

  describe "board with two unsolved tiles" do
    before do
      @guesses = [[0, 8, 4], [6, 6, 4]]
      @almost_solved_game = Proc.new {Game.new(
          file: 'test/fixtures/sudoku_almost_2.txt',
          presenter: Presenter.new,
          guesses: @guesses
        )}
    end

    it "renders the board" do
      @almost_solved_game.must_output(/\+-------\+-------\+-------\+/)
    end

    it "displays the win message" do
      @almost_solved_game.must_output(/WIN!/)
    end
  end
end

describe "Mocking" do
  describe "a game with one unsolved tile" do
    before do
      @MockPresenter = Minitest::Mock.new
      def @MockPresenter.render(grid); end
      def @MockPresenter.prompt_x; 0 end
      def @MockPresenter.prompt_y; 8 end
      def @MockPresenter.prompt_tile_value; 4 end
      def @MockPresenter.win_msg; end

      Game.new(
        file: 'test/fixtures/sudoku_almost.txt',
        presenter: @MockPresenter
      )
    end
  end
end
