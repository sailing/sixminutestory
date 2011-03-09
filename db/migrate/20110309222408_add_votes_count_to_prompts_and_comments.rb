class AddVotesCountToPromptsAndComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :votes_count, :integer, :default => 0
    add_column :prompts, :votes_count, :integer, :default => 0
  end

  def self.down
    remove_column :comments, :votes_count
    remove_column :prompts, :votes_count
  end
  
end