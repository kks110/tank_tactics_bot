class AddDisabledUntilToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :disabled_until, :datetime
  end
end
