class AddEmailToOrganizations < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :email, :string, default: nil
  end
end
