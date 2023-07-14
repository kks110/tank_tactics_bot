class CreateHearts < ActiveRecord::Migration[7.0]
  def change
    create_table :hearts do |t|
      t.integer :x_position
      t.integer :y_position
    end
  end
end
