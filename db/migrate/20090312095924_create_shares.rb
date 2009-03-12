class CreateShares < ActiveRecord::Migration
  def self.up
    create_table :shares do |t|
      t.string :link
      t.string :title
      t.text :description
      t.string :website
      t.string :source
      t.string :alternative_contact
      t.boolean :active, :default => 1
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :shares
  end
end
