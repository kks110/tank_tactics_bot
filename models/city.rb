require 'active_record'

class City < ActiveRecord::Base
  belongs_to :player

  validates :x_position, :y_position, presence: true

  def coords
    { x: x_position, y: y_position }
  end

  def to_hash
    {
      "x": x_position,
      "y": y_position,
      "player": player&.username
    }
  end
end
