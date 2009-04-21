class AddingDeltaToShare < ActiveRecord::Migration
  def self.up
    add_column :shares, :delta, :boolean
  end

  def self.down
    remove_column :shares, :delta
  end
end
