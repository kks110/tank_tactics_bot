class CreateBoardImages < ActiveRecord::Migration[7.0]
  def change
    create_table :board_images do |t|
      t.bigint :discord_id, null: false
      t.text :image_file_path, null: false
      t.datetime :created_at, default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
