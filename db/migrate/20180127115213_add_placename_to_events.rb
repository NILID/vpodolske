class AddPlacenameToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :placename, :string
  end
end
