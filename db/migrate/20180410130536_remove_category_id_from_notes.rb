class RemoveCategoryIdFromNotes < ActiveRecord::Migration[4.2]
  def change
    remove_column :notes, :category_id
  end
end
