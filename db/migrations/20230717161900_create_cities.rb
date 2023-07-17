class CreateCities < ActiveRecord::Migration[7.0]
  def change
    create_table :cities do |t|
      t.integer :x_position
      t.integer :y_position
      t.belongs_to :player
    end
  end
end
