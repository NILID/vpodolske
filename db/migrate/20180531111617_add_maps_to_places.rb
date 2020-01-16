class AddMapsToPlaces < ActiveRecord::Migration[4.2]
  def change
    add_column :places, :address, :text, default: nil
    add_column :places, :longitude, :float
    add_column :places, :latitude, :float
  end
end
