class AddFinishtimeAndFinishdateToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :finishtime, :time
    add_column :events, :finishdate, :date
  end
end
