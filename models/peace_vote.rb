require 'active_record'

class PeaceVote < ActiveRecord::Base
  belongs_to :player

  validates :player, presence: true
end
