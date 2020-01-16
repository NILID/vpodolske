class AddWorktimeToAddresses < ActiveRecord::Migration[4.2]
  def change
    add_column :addresses, :worktime, :string, default: nil
  end
end
