class AddTitleToBlock < ActiveRecord::Migration[5.2]
  def change
    add_column :blocks, :title, :string
  end
end
