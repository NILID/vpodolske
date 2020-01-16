class AddHiddenToComments < ActiveRecord::Migration[4.2]
  def change
    add_column :comments, :hidden, :boolean, default: true, null: false
  end
end
