require 'active_record'

class EnergyCell < ActiveRecord::Base
  validates :x_position, :y_position, presence: true

  def coords
    { x: x_position, y: y_position }
  end
end
