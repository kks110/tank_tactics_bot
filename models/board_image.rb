require 'active_record'

class BoardImage < ActiveRecord::Base
  validates :discord_id, :image_file_path, presence: true
  validates :discord_id, :image_file_path, uniqueness: true
end
