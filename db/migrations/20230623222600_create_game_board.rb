class CreateGameBoard < ActiveRecord::Migration[7.0]
  def change
    create_table :game_boards do |t|
      t.integer :max_x
      t.integer :max_y
    end
  end
end