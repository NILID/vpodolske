class AddUrlToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :url, :text
    remove_column :articles, :content
  end
end
