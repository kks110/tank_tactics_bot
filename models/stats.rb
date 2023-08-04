require 'active_record'

class Stats < ActiveRecord::Base
  belongs_to :player

  def self.column_headings
    titles = column_names.clone(freeze: false)
    titles.delete('id')
    titles.delete('player_id')
    titles.unshift('username')

    titles.map { |title| title.gsub('_', ' ').capitalize }
  end
end
