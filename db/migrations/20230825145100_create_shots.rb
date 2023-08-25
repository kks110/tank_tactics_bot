class CreateShots < ActiveRecord::Migration[7.0]
  def change
    create_table :shots do |t|
      t.belongs_to :player
      t.integer :count, default: 0
      t.datetime :created_at
    end
  end
end
