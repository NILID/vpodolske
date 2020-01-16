class AddNewToVotable < ActiveRecord::Migration[4.2]
  def self.up
    add_column :votes, :vote_scope, :string
    add_column :votes, :vote_weight, :integer

    add_index :votes, [:voter_id, :voter_type, :vote_scope]
    add_index :votes, [:votable_id, :votable_type, :vote_scope]
  end

  def self.down
  end
end
