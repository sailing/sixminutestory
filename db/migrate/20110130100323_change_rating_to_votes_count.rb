class ChangeRatingToVotesCount < ActiveRecord::Migration
  def self.up
    rename_column :stories, :rating, :votes_count
  end

  def self.down
    rename_column :stories, :rating, :votes_count
  end
end