class CreateEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :events do |t|
      t.string :title
      t.text :content
      t.integer :user_id
      t.string :url
      t.has_attached_file :src
      t.time :eventime
      t.date :eventdate
      t.boolean :hidden, default: true
      t.boolean :cool, default: false

      t.integer :cached_votes_total, :default => 0
      t.integer :cached_votes_up, :default => 0
      t.integer :cached_votes_down, :default => 0

      t.timestamps
    end
    add_index :events, :hidden
    add_index :events, :cool
    add_index :events, :user_id
    add_index :events, :cached_votes_total
    add_index :events, :cached_votes_up
    add_index :events, :cached_votes_down
  end
end
