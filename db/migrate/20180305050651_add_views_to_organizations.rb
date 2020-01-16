class AddViewsToOrganizations < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :views, :integer, default: 0, null: false
  end
end
