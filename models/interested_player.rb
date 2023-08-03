require 'active_record'

class InterestedPlayer < ActiveRecord::Base
  validates :discord_id, presence: true
  validates :discord_id, uniqueness: true
end
