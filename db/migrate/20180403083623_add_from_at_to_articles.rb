class AddFromAtToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :from_at, :datetime
  end
end
