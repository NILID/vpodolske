class AddOmniauthToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :integer
  end
end
