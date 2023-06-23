
class Player < ActiveRecord::Base
  validates :discord_id, :user_name, presence: true
  validates :discord_id, :user_name, uniqueness: true
end