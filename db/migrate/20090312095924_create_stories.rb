class CreateStories < ActiveRecord::Migration
  def self.up
    create_table :stories do |t|
      t.string :title
      t.text :description
      t.string :license
      t.integer :rating, :default => 0

      t.references :user
      t.references :prompt
      t.references :contest, :default => 0


      t.boolean :delta, :default => false      
      t.boolean :active, :default => true
      
      t.timestamps
    end
  end

  def self.down
    drop_table :stories
  end
end
