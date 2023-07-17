class AddCityCapturesToPlayer < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :city_captures, :integer, default: 0
  end
end
