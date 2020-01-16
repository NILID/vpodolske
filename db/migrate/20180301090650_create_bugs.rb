class CreateBugs < ActiveRecord::Migration[4.2]
  def change
    create_table :bugs do |t|
      t.text :content
      t.text :url
      t.integer :status

      t.timestamps null: false
    end
  end
end
