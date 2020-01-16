class ChangeSiteurlToBeTextareaInEvents < ActiveRecord::Migration[4.2]
  def change
    change_column :events, :siteurl, :text, default: nil
  end
end
