class AddEmailToNotes < ActiveRecord::Migration[4.2]
  def change
    add_column :notes, :email, :string, default: nil
  end
end
