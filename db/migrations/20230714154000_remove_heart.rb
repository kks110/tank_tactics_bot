class RemoveHeart < ActiveRecord::Migration[7.0]
  def up
    remove_column :games, :heart_x
    remove_column :games, :heart_y
  end
end
