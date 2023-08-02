require 'active_record'

class Statistic < ActiveRecord::Base
  belongs_to :player
end
