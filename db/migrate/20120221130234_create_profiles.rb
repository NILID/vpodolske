class CreateProfiles < ActiveRecord::Migration[4.2]
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.text :aboutme
      t.has_attached_file :avatar
      t.string :gender, :limit => 1, :default => nil

      t.timestamps
    end
    add_index :profiles, :user_id, :unique => true
  end
end
