require 'active_record'

class GlobalStats < ActiveRecord::Base
  validates :player_discord_id, :username, presence: true
  validates :player_discord_id, :username, uniqueness: true
end
