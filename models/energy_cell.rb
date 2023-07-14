require 'active_record'

class EnergyCell < ActiveRecord::Base
  validates :x_position, :y_position, presence: true
  validate :only_one_item

  def coords
    { x: x_position, y: y_position }
  end

  private
  def only_one_item
    errors.add(:base, "Only one item allowed") if EnergyCell.count > 0
  end
end
