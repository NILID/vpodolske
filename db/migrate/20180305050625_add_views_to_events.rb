class AddViewsToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :views, :integer, default: 0, null: false
  end
end
