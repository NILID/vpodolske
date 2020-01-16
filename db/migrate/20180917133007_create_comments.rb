class CreateComments < ActiveRecord::Migration[4.2]
  def change
    create_table :comments do |t|
      t.text :content
      t.references :user, index: true, foreign_key: true
      t.references :commentable, polymorphic: true, index: true
      t.integer :state
      t.string :ancestry

      t.timestamps null: false
    end
    add_index :comments, :ancestry
  end
end
