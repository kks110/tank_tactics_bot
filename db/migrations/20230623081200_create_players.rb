class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.bigint :discord_id, null: false
      t.text :username, null: false
      t.text :x_position
      t.text :y_position
      t.integer :energy, default: 0, null: false
      t.integer :hp, default: 3, null: false
      t.integer :range, default: 2, null: false
      t.boolean :alive, default: true
      t.boolean :admin, default: false
    end
  end
end