class Tile
  attr_accessor :tile, :presenter
  attr_reader :mutable

  def initialize(tile, presenter)
    @mutable = tile == "0"
    @tile    = tile == "0" ? "-" : tile
    @presenter = presenter
  end

  def tile=(new_tile)
    if mutable
      @tile = new_tile
    else
      presenter.immutable_tile_msg
    end
  end
end
