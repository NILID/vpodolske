class CreateCategoriesOrganizations < ActiveRecord::Migration[4.2]
  def change
    create_table :categories_organizations, id: false do |t|
      t.belongs_to :category, index: true
      t.belongs_to :organization, index: true
    end
  end
end
