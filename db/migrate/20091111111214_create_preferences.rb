class CreatePreferences < ActiveRecord::Migration
  def self.up
    add_column :users, :send_comments, :boolean, :default => 1
    add_column :users, :send_stories, :boolean, :default => 1
    add_column :users, :send_followings, :boolean, :default => 1
    
  end
  
  def self.down
      remove_column :users, :send_comments
      remove_column :users, :send_stories
      remove_column :users, :send_followings
  end
end
