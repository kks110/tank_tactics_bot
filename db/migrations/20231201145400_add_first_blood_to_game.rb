class AddFirstBloodToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :someone_got_first_blood, :boolean, default: false
  end
end
