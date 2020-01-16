class AddNotifyFlagToOrganizations < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :notify, :boolean, default: false
  end
end
