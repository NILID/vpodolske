class CreateNotes < ActiveRecord::Migration[4.2]
  def change
    create_table :notes do |t|
      t.text :content
      t.references :category
      t.references :user

      t.timestamps
    end
  end
end
