class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.bigint :discord_id, null: false
      t.text :username, null: false
      t.integer :x_position
      t.integer :y_position
      t.integer :energy, default: 0, null: false
      t.integer :hp, default: 3, null: false
      t.integer :range, default: 2, null: false
      t.boolean :alive, default: true
      t.boolean :admin, default: false
      t.integer :kills, default: 0
      t.integer :deaths, default: 0
    end
  end
end