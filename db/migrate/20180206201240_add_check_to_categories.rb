class AddCheckToCategories < ActiveRecord::Migration[4.2]
  def change
    add_column :categories, :check, :boolean, default: false
  end
end
