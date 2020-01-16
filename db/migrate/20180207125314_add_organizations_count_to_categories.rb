class AddOrganizationsCountToCategories < ActiveRecord::Migration[4.2]
  def change
    add_column :categories, :organizations_count, :integer, default: 0, null: false

    Category.reset_column_information
    Category.all.each do |c|
      Category.update_counters c.id, :organizations_count => c.organizations.length
    end
  end
end
