class CreatePeaceVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :peace_votes do |t|
      t.belongs_to :player
      t.datetime :created_at
    end
  end
end
