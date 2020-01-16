class ChangeSettingsToCkeditor < ActiveRecord::Migration[4.2]
  def self.up
    remove_column :ckeditor_assets, :assetable_id
    remove_column :ckeditor_assets, :assetable_type
    # TODO
    # why not remove
    #
    # remove_index  :ckeditor_assets, name: 'ckeditor_assetable_type'
    # remove_index  :ckeditor_assets, name: 'ckeditor_assetable'

    add_column :ckeditor_assets, :width, :integer
    add_column :ckeditor_assets, :height, :integer
    add_column :ckeditor_assets, :data_fingerprint, :string
    add_index  :ckeditor_assets, :type
  end

  def self.down
  end
end
