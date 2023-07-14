class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.bigint :server_id, null: false
      t.integer :max_x, null: false
      t.integer :max_y, null: false
      t.integer :heart_x
      t.integer :heart_y
    end
  end
end
