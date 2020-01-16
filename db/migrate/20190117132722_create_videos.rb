class CreateVideos < ActiveRecord::Migration[4.2]
  def change
    create_table :videos do |t|
      t.string :title
      t.text :url
      t.integer :likers_count, default: 0
      t.integer :views, default: 0
      t.integer :comments_count, default: 0


      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
