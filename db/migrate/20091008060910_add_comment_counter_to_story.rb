class AddCommentCounterToStory < ActiveRecord::Migration
  def self.up
    add_column :stories, :comment_counter, :integer, :default => 0
  end

  def self.down
    remove_column :stories, :comment_counter
  end
end
