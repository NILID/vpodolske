class ChangeRolesMaskToUsers < ActiveRecord::Migration[4.2]
  def self.up
    change_column :users, :roles_mask, :integer, :default => '8'
  end

  def self.down
    change_column :users, :roles_mask, :integer, :default => '2'
  end

end
