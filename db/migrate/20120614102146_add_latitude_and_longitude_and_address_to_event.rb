class AddLatitudeAndLongitudeAndAddressToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :address, :string
    add_column :events, :latitude, :float
    add_column :events, :longitude, :float
    add_column :events, :gmaps, :boolean
  end
end
