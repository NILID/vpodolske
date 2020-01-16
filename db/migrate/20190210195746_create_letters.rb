class CreateLetters < ActiveRecord::Migration[5.0]
  def change
    create_table :letters do |t|
      t.text :content, null: false
      t.string :email, null: false

      t.timestamps
    end
  end
end
