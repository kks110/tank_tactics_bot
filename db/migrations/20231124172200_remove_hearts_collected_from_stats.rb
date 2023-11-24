class RemoveHeartsCollectedFromStats < ActiveRecord::Migration[7.0]
  def change
    remove_column :stats, :hearts_collected
  end
end
