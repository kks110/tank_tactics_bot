require 'active_record'

class Game < ActiveRecord::Base
  validates :server_id, :max_x, :max_y, presence: true
  validates :server_id, uniqueness: true

  validates :cities, inclusion: [true, false]
  validates :cities, exclusion: [nil]

  validates :fog_of_war, inclusion: [true, false]
  validates :fog_of_war, exclusion: [nil]
end
