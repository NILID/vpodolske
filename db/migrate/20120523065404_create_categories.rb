class CreateCategories < ActiveRecord::Migration[4.2]
  def change
    create_table :categories do |t|
      t.string :title
      t.string :slug
      t.references :categorable, polymorphic: true
      t.text :desc
    end
    add_index :categories, :title, :unique => true
    add_index :categories, :slug, :unique => true
  end
end
