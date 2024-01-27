require 'active_record'

class Player < ActiveRecord::Base
  has_one :peace_vote
  has_one :stats
  has_one :shot
  has_many :city

  validates :discord_id, :username, :energy, :hp, :range, presence: true
  validates :discord_id, :username, uniqueness: true


  def alive?
    hp.positive?
  end

  def disabled?
    return false if disabled_until.nil?

    disabled_until > DateTime.now
  end

  def to_hash
    {
      "name": username,
      "x": x_position,
      "y": y_position,
      "energy": energy,
      "hp": hp,
      "range": range,
      "disabled_until": disabled_until,
      "shot_count": shot&.count,
      "shot_created_at": shot&.created_at
    }
  end
end
