class AddFeaturedColumnToStories < ActiveRecord::Migration
  def self.up
        add_column :stories, :featured, :boolean, :default => 0
        add_column :users, :featured, :boolean, :default => 0
  end

  def self.down
        remove_column :stories, :featured
        remove_column :users, :featured
  end
end
