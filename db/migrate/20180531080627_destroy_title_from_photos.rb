class DestroyTitleFromPhotos < ActiveRecord::Migration[4.2]
  def change
    remove_column :photos, :title
    add_column :photos, :content, :text, default: nil
  end
end
