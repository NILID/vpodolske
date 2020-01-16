class AddSiteurlToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :siteurl, :string, default: nil
    add_index :events, :siteurl
  end
end
