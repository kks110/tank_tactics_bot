require 'active_record'

class PeaceVote < ActiveRecord::Base
  belongs_to :player

  validates :player, presence: true, uniqueness: true

  def to_hash
    {
      "player": player.username,
      "created_at": created_at,
    }
  end
end
