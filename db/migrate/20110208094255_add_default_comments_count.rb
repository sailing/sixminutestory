class AddDefaultCommentsCount < ActiveRecord::Migration
  def self.up
    change_column_default :stories, :comments_count, "0"
    change_column_default :users, :comments_count, "0"
    change_column_default :users, :stories_count, "0"
    change_column_default :prompts, :stories_count, "0"
  end

  def self.down
    change_column_default :stories, :comments_count, "0"
    change_column_default :users, :comments_count, "0"
    change_column_default :users, :stories_count, "0"
    change_column_default :prompts, :stories_count, "0"
  end
end