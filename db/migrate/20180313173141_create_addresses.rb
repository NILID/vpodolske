class CreateAddresses < ActiveRecord::Migration[4.2]
  def change
    create_table :addresses do |t|
      t.references :organization, index: true, foreign_key: true
      t.text :address
      t.float :longitude
      t.float :latitude

      t.timestamps null: false
    end

    Organization.all.each do |o|
      o.addresses.create!(address: o.address, longitude: o.longitude, latitude: o.latitude)
    end
  end
end
