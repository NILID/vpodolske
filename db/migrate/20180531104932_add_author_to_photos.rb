class AddAuthorToPhotos < ActiveRecord::Migration[4.2]
  def change
    add_column :photos, :author, :string, default: nil
  end
end
