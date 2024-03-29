class AddLastChangeToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :last_change, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
