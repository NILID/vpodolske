class AddTimelessToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :timeless, :boolean, default: false
  end
end
