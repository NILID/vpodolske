class AddYearToPhotos < ActiveRecord::Migration[4.2]
  def change
    add_column :photos, :year, :integer
  end
end
