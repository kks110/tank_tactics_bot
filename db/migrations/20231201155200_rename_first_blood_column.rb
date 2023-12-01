class RenameFirstBloodColumn < ActiveRecord::Migration[7.0]
  def change
    rename_column :games, :someone_got_first_blood, :first_blood
  end
end
