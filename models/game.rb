require 'active_record'

class Game < ActiveRecord::Base
  validates :server_id, :max_x, :max_y, presence: true
  validates :server_id, uniqueness: true

  def to_hash
    {
      "max_x": max_x,
      "max_y": max_y,
      "first_blood": first_blood
    }
  end
end
