class CreateInterestedPlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :interested_players do |t|
      t.bigint :discord_id, null: false
    end
  end
end
