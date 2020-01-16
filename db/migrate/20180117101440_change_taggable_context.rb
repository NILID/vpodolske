class ChangeTaggableContext < ActiveRecord::Migration[4.2]
  def self.up
    change_column :taggings, :context, :string, limit: 128
  end

  def self.down
    change_column :taggings, :context, :string
  end
end
