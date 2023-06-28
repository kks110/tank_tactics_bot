require 'active_record'

class Player < ActiveRecord::Base
  validates :discord_id, :username, :energy, :hp, :range, presence: true
  validates :discord_id, :username, uniqueness: true
end