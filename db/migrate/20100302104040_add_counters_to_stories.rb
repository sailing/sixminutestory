class AddCountersToStories < ActiveRecord::Migration
  def self.up
        add_column :stories, :comments_count, :integer

        add_column :users, :comments_count, :integer
        add_column :users, :stories_count, :integer
        
        add_column :prompts, :stories_count, :integer
        
  end

  def self.down
        remove_column :prompts, :stories_count

        remove_column :users, :stories_count
        remove_column :users, :comments_count

        remove_column :stories, :comments_count
        
  end
end
