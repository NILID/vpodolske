class AddProviderToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :provider, :string, index: true, foreign_key: true
  end
end
