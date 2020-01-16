class AddUserIdToOrganizations < ActiveRecord::Migration[4.2]
  def change
    add_reference :organizations, :user, index: true, foreign_key: true
  end
end
