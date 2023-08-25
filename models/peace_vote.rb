require 'active_record'

class PeaceVote < ActiveRecord::Base
  belongs_to :player

  validates :player, presence: true, uniqueness: true
end
