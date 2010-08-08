class AddPromptOptions < ActiveRecord::Migration
  def self.up
    add_column :prompts, :refcode, :string
    add_column :prompts, :kind, :string
    add_column :prompts, :attribution, :string
    add_column :prompts, :attribution_url, :string
    add_column :prompts, :license, :string
  end

  def self.down
    remove_column :prompts, :refcode
    remove_column :prompts, :kind
    remove_column :prompts, :attribution
    remove_column :prompts, :attribution_url
    remove_column :prompts, :license
  end
end
