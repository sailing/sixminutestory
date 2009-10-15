class CreateContests < ActiveRecord::Migration
  def self.up
    create_table :contests do |t|
      t.string :title
      t.text :description
      t.datetime :start
      t.datetime :end

      t.references :user 
      t.references :prompt, :default => 0
           
      t.boolean :active, :default => true
      t.boolean :delta, :default => false      


      t.timestamps
    end
  end

  def self.down
    drop_table :contests
  end
end
