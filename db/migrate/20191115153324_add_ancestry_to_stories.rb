class AddAncestryToStories < ActiveRecord::Migration[5.2]
  def change
    add_column :stories, :ancestry, :string
    add_index :stories, :ancestry

    add_column :stories, :ancestry_depth, :integer, :default => 0

    Story.rebuild_depth_cache!
  end
end
