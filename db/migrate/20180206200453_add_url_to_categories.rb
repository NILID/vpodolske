class AddUrlToCategories < ActiveRecord::Migration[4.2]
  def change
    add_column :categories, :url, :text
  end
end
