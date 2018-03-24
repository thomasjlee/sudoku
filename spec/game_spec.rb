require_relative "./../game"

RSpec.describe Game, "#initialize" do
  context "initialized with a file" do

    # if initialized with a file, it does not call start_prompt TODO looks like a test for the Presenter class
    it "does not call Presenter#start_prompt" do
      file = './spec/fixtures/sudoku_almost.txt'
      presenter = instance_double("Presenter")
      allow(presenter).to receive(:start_prompt)
      allow(presenter).to receive(:render)
      allow(presenter).to receive(:prompt_x).and_return(0)
      allow(presenter).to receive(:prompt_y).and_return(8)
      allow(presenter).to receive(:prompt_tile_value).and_return(4)
      allow(presenter).to receive(:win_msg)

      expect(presenter).to_not receive(:start_prompt)

      Game.new(file: file, presenter: presenter)
    end

    # if initialized with a file, it will have a board
    it "has a board" do
      file = './spec/fixtures/sudoku_almost.txt'
      presenter = instance_double("Presenter")
      allow(presenter).to receive(:start_prompt)
      allow(presenter).to receive(:render)
      allow(presenter).to receive(:prompt_x).and_return(0)
      allow(presenter).to receive(:prompt_y).and_return(8)
      allow(presenter).to receive(:prompt_tile_value).and_return(4)
      allow(presenter).to receive(:win_msg)

      game = Game.new(file: file, presenter: presenter)

      expect(game.board).to be_a_kind_of(Board)
    end
  end


  # if initialized without a file, it calls start_prompt
  context "initialized without a file" do

    it "calls Presenter#start_prompt" do
      presenter = instance_double("Presenter")
      allow(presenter).to receive(:start_prompt)
      allow(presenter).to receive(:render)
      allow(presenter).to receive(:prompt_x).and_return(0)
      allow(presenter).to receive(:prompt_y).and_return(8)
      allow(presenter).to receive(:prompt_tile_value).and_return(4)
      allow(presenter).to receive(:win_msg)

      expect(presenter).to receive(:start_prompt)

      Game.new(presenter: presenter)
    end
  end

end
