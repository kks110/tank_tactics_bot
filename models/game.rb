require 'active_record'

class Game < ActiveRecord::Base
  validates :server_id, :max_x, :max_y, presence: true
  validates :server_id, uniqueness: true
end
