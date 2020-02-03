class CreateBlocks < ActiveRecord::Migration[5.2]
  def change
    create_table :blocks do |t|
      t.text :content
      t.string :type
      t.integer :position
      t.belongs_to :page, foreign_key: true

      t.timestamps
    end
  end
end
