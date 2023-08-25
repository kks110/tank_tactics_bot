require 'active_record'

class Shot < ActiveRecord::Base
  belongs_to :player

  validates :player_id, uniqueness: true
end
