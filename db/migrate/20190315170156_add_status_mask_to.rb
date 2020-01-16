class AddStatusMaskTo < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :status_mask, :integer, default: 1, null: false
    Organization.all.each do |o|
      o.update_attribute(:status_mask, (o.hidden ? 1 : 2))
    end
  end
end
