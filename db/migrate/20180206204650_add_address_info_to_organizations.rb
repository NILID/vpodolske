class AddAddressInfoToOrganizations < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :postal_code, :integer
    add_column :organizations, :address_region, :string
    add_column :organizations, :address_locality, :string
    add_column :organizations, :street_address, :text
    add_column :organizations, :office, :text
    add_column :organizations, :url, :text
  end
end
