# require_relative 'sudoku'
require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

describe "Sample test" do
  it "should run this test" do
    assert_equal 1 + 1, 2
  end
end
