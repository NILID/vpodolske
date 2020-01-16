class CreateOrganizations < ActiveRecord::Migration[4.2]
  def change
    create_table :organizations do |t|
      t.text :title, null: false
      t.text :old_title, null: false
      t.attachment :logo
      t.text :desc
      t.float :longitude
      t.float :latitude
      t.text :address
      t.string :site
      t.text :worktime
      t.text :phone

      t.timestamps null: false
    end
  end
end
