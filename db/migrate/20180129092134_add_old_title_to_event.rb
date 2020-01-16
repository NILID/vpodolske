class AddOldTitleToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :old_title, :string

    Event.all.each do |e|
      e.update_attribute(:old_title, e.title)
    end
  end
end
