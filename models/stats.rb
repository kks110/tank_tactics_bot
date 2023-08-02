require 'active_record'

class Stats < ActiveRecord::Base
  belongs_to :player
end
