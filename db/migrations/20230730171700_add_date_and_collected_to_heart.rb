class AddDateAndCollectedToHeart < ActiveRecord::Migration[7.0]
  def change
    add_column :hearts, :created_at, :datetime
    add_column :hearts, :collected, :boolean, default: false
  end
end
