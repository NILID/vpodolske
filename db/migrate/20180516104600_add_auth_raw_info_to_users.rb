class AddAuthRawInfoToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :auth_raw_info, :text
  end
end
