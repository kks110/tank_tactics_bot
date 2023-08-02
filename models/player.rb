require 'active_record'

class Player < ActiveRecord::Base
  has_one :peace_vote
  has_one :statistic
  has_many :city

  validates :discord_id, :username, :energy, :hp, :range, presence: true
  validates :discord_id, :username, uniqueness: true
end
