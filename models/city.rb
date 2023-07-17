require 'active_record'

class City < ActiveRecord::Base
  belongs_to :player

  validates :x_position, :y_position, presence: true

  def coords
    { x: x_position, y: y_position }
  end
end
