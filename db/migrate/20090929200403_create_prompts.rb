class CreatePrompts < ActiveRecord::Migration
  def self.up
    create_table :prompts do |t|
      t.string :hero
      t.string :villain
      t.string :goal
      t.date :use_on
      t.integer :rating, :default => 0
      t.integer :counter, :default => 0
      
      t.references :user      
      t.references :contest, :default => 0

      t.boolean :active, :default => true
      t.boolean :verified, :default => true
      t.boolean :delta, :default => false      
      
      t.timestamps
    end
  end

  def self.down
    drop_table :prompts
  end
end
