class AddCountColumnsToPromptAndStories < ActiveRecord::Migration
  def self.up
    add_column :stories, :counter, :integer, :default => 0
    add_column :prompts, :counter, :integer, :default => 0
    add_column :prompts, :rating, :integer, :default => 0
  end

  def self.down
    remove_column :prompts, :counter
    remove_column :stories, :counter
    remove_column :prompts, :rating
  end
end
