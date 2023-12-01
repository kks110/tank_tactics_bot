class AddFirstBloodAndFirstKill < ActiveRecord::Migration[7.0]
  def change
    add_column :stats, :first_blood, :integer, default: 0
    add_column :stats, :first_death, :integer, default: 0
    add_column :global_stats, :first_blood, :integer, default: 0
    add_column :global_stats, :first_death, :integer, default: 0
  end
end
