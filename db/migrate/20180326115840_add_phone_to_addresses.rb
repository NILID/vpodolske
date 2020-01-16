class AddPhoneToAddresses < ActiveRecord::Migration[4.2]
  def change
    add_column :addresses, :phone, :string
  end
end
