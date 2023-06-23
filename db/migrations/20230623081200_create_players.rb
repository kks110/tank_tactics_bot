class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.integer :discord_id
      t.text :user_name
    end
  end
end