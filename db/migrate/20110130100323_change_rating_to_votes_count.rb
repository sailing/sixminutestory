class ChangeRatingToVotesCount < ActiveRecord::Migration
  def self.up
    rename_column :stories, :rating, :votes_count
    
    
    Story.reset_column_information
    Story.all.each do |s|
      Story.update_counters s.id, :votes_count => s.votes_for, :comments_count => s.comments.length
    end
  end

  def self.down
    rename_column :stories, :votes_count, :rating
  end
end