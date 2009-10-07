class AddFlaggedColumnToStories < ActiveRecord::Migration
  def self.up
    add_column :stories, :flagged, :integer, :default => 0
  end

  def self.down
    remove_column :stories, :flagged
  end
end
