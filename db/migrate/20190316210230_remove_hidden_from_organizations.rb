class RemoveHiddenFromOrganizations < ActiveRecord::Migration[5.0]
  def change
    remove_column :organizations, :hidden
  end
end
