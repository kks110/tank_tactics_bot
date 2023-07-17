class AddCitiesToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :cities, :boolean
  end
end
