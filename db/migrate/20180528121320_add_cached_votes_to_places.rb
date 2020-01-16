class AddCachedVotesToPlaces < ActiveRecord::Migration[4.2]
  def change
    add_column :places, :cached_votes_total, :integer, default: 0
    add_column :places, :cached_votes_score, :integer, default: 0
    add_column :places, :cached_votes_up, :integer, default: 0
    add_column :places, :cached_votes_down, :integer, default: 0
    add_column :places, :cached_weighted_score, :integer, default: 0
    add_column :places, :cached_weighted_total, :integer, default: 0
    add_column :places, :cached_weighted_average, :float, default: 0.0

    Place.find_each(&:update_cached_votes)
  end
end
